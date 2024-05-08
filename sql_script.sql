--1CTE (base_data) обрізаю дату платежу до місяця (payment_month) та використовую функцію SUM для агрегації ревенню (total_revenue) 
with base_data as (
  select
    user_id,
    date_trunc('month', payment_date) AS payment_month,
    sum(revenue_amount_usd) AS total_revenue
  from
    project.games_payments gp
  group by
    user_id, payment_month
),
--2CTE (payment_data) беру за основу дані з таблиці (base_data) та додаю нові колонки
payment_data as (
  select
    *,
    payment_month - INTERVAL '1 month' AS previous_calendar_month,
    payment_month + INTERVAL '1 month' AS next_calendar_month,
    lag(total_revenue,1) over (partition by user_id order by payment_month) as previous_month_revenue, -- Попередня сума платежів за допомогою віконної функції LAG
    lead(total_revenue,1) over (partition by user_id order by payment_month) as next_month_revenue, 
    lag(payment_month) over (partition by user_id order by payment_month) as previous_payment_month, -- Попередній місяць платежу за допомогою віконної функції LAG
    lead(payment_month) over (partition by user_id order by payment_month) as next_payment_month, -- Наступний місяць платежу за допомогою віконної функції LEAD
  	min(payment_month) over (partition by user_id) AS first_payment_month, -- Перший місяць платежу для кожного користувача
  	max(payment_month) over (partition by user_id) AS last_payment_month -- Останній місяць платежу для кожного користувача
  from
    base_data
),
-- 3СТЕ Розрахунок метрик
revenue_metrics as (
	select 
		*,
		-- New Paid User - кількість нових платних користувачів
		case 
			when previous_payment_month is null 
			then user_id 
		end as new_paid_users,  
    	-- New MRR - це MRR згенерований користувачами, що стали платними у відповідний місяць. 
    	case 
	    	when previous_payment_month is null
	    	then total_revenue
    	end as new_mrr, 
       	-- Churned Users - кількість користувачів що припинили платити у відповідний період часу
    	case 
	    	when next_month_revenue is null 
	    	or next_payment_month <> next_calendar_month 
	    	then user_id
	    end as churned_users, 
    	-- Churned revenue - сумарний revenue за попередній період від усіх користувачів, що припинили платити
    	case 
    		when next_month_revenue is null 
    		or next_payment_month <> next_calendar_month 
    		then total_revenue
    	end as churned_revenue,
    	-- Back from churn users - кількість реактивованих користувачів
    	case 
	    	when previous_payment_month <> previous_calendar_month 
	    	and previous_payment_month is not null 
	    	then user_id
	    end as back_from_churn_users,
    	-- Back from churn Revenue - дохід, отриманий від реактивованих користувачів
 		case 
	 		when previous_payment_month <> previous_calendar_month 
	 		and previous_payment_month is not null 
	 		then total_revenue 
	 	end as back_from_churn_revenue,
    	-- Expansion MRR - це сума, на яку збільшилася MRR від одного місяця до іншого. Рахується за користувачами, що стали платити більше в поточному місяці
 		case 
	 		when previous_payment_month = previous_calendar_month 
	 		and total_revenue > previous_month_revenue 
	 		then total_revenue - previous_month_revenue 
	 	end as exprension_mrr, 
 		-- Contraction MRR - це сума, на яку зменшилася MRR від одного місяця до іншого. Рахується за користувачами, що стали платити менше в поточному місяці
 		case 
	 		when previous_payment_month = previous_calendar_month 
	 		and previous_month_revenue > total_revenue 
	 		then total_revenue - previous_month_revenue 
	 	end as contraction_mrr
 	from 
		payment_data
)
-- 4 Фінальний СТЕ
select 
	rv.user_id, 
	payment_month,
	first_payment_month,
	last_payment_month,
	new_paid_users,
	churned_users,
	total_revenue,
	case when new_mrr is not null then 'new mrr'
		when churned_revenue is not null then 'churned revenue'
		when exprension_mrr is not null then 'exprension_mrr'
		when contraction_mrr is not null then 'contraction_mr' 
	end as revenue_metrics,
	case when new_paid_users is not null then 'new_paid_users'
		when churned_users is not null then 'churned_users'
		when back_from_churn_users is not null then 'back_from_churn_users'
	end as users_metrics,
	new_mrr,
	churned_revenue, 
	back_from_churn_revenue,
	back_from_churn_users,
	exprension_mrr,
	contraction_mrr,
	game_name, gpu."language", 
	gpu.has_older_device_model, 
	gpu."language"
from 
	revenue_metrics rv
left join project.games_paid_users gpu on gpu.user_id=rv.user_id;