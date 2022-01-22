
## 1 . Create a new table named 'bajaj1' containing the date, close price, 20 Day MA and 50 Day MA. (This has to be done for all 6 stocks)

# bajaj auto 

select * from bajaj_auto;

alter table `bajaj_auto`
add ano_date date;

update `bajaj_auto` 
set ano_date = str_to_date(date, '%d-%M-%Y');

create table bajaj1
  as (select ano_date as `Date`, `Close Price` as  `Close Price` , 
  avg(`Close Price`) over (order by ano_date asc rows 19 preceding) as `20 Day MA`,
  avg(`Close Price`) over (order by ano_date asc rows 49 preceding) as `50 Day MA`,
  row_number() over (order by `ano_date` ) as `row_num`
  from `bajaj_auto`);

# ignoring values as calculation is inappropriate because some values will be NULL
delete from bajaj1 
where  row_num < 50;

alter table bajaj1
drop column row_num;
  
select * from bajaj1 order by Date;

# EICHER MOTO

select * from eicher_motors;

alter table `eicher_motors`
add ano_date date;

update `eicher_motors` 
set ano_date = str_to_date(date, '%d-%M-%Y');

create table eicher1
  as (select ano_date as `Date`, `Close Price` as  `Close Price` , 
  avg(`Close Price`) over (order by ano_date asc rows 19 preceding) as `20 Day MA`,
  avg(`Close Price`) over (order by ano_date asc rows 49 preceding) as `50 Day MA`,
  row_number() over (order by `ano_date` ) as `row_num`
  from `eicher_motors`);
  
# ignoring values as calculation is inappropriate because some values will be NULL
delete from eicher1 
where  row_num < 50;

alter table eicher1
drop column row_num;
  
select * from eicher1;

# HERO MOTOCORP

select * from hero_motocorp;

alter table `hero_motocorp`
add ano_date date;

update `hero_motocorp` 
set ano_date = str_to_date(date, '%d-%M-%Y');

create table hero1
  as (select ano_date as `Date`, `Close Price` as  `Close Price` , 
  avg(`Close Price`) over (order by ano_date asc rows 19 preceding) as `20 Day MA`,
  avg(`Close Price`) over (order by ano_date asc rows 49 preceding) as `50 Day MA`,
  row_number() over (order by `ano_date` ) as `row_num`
  from `hero_motocorp`);
  
# ignoring values as calculation is inappropriate because some values will be NULL
delete from hero1 
where  row_num < 50;

alter table hero1
drop column row_num;
  
select * from hero1;

# INFOSYS
select * from infosys;

alter table `infosys`
add ano_date date;

update `infosys` 
set ano_date = str_to_date(date, '%d-%M-%Y');

create table infosys1
  as (select ano_date as `Date`, `Close Price` as  `Close Price` , 
  avg(`Close Price`) over (order by ano_date asc rows 19 preceding) as `20 Day MA`,
  avg(`Close Price`) over (order by ano_date asc rows 49 preceding) as `50 Day MA`,
  row_number() over (order by `ano_date` ) as `row_num`
  from `infosys`);
  
# ignoring values as calculation is inappropriate because some values will be NULL
delete from infosys1 
where  row_num < 50;

alter table infosys1
drop column row_num;
  
select * from infosys1;

# TCS

select * from tcs;

alter table `tcs`
add ano_date date;

update `tcs` 
set ano_date = str_to_date(date, '%d-%M-%Y');

create table tcs1
  as (select ano_date as `Date`, `Close Price` as  `Close Price` , 
  avg(`Close Price`) over (order by ano_date asc rows 19 preceding) as `20 Day MA`,
  avg(`Close Price`) over (order by ano_date asc rows 49 preceding) as `50 Day MA`,
  row_number() over (order by `ano_date` ) as `row_num`
  from `tcs`);
  
# ignoring values as calculation is inappropriate because some values will be NULL
delete from tcs1 
where  row_num < 50;

alter table tcs1
drop column row_num;
  
select * from tcs1;

# TVS MOTORS
select * from tvs_motors;

alter table `tvs_motors`
add ano_date date;

update `tvs_motors` 
set ano_date = str_to_date(date, '%d-%M-%Y');

create table tvs1
  as (select ano_date as `Date`, `Close Price` as  `Close Price` , 
  avg(`Close Price`) over (order by ano_date asc rows 19 preceding) as `20 Day MA`,
  avg(`Close Price`) over (order by ano_date asc rows 49 preceding) as `50 Day MA`,
  row_number() over (order by `ano_date` ) as `row_num`
  from `tvs_motors`);
  
# ignoring values as calculation is inappropriate because some values will be NULL
delete from tvs1 
where  row_num < 50;

alter table tvs1
drop column row_num;
  
select * from tvs1; 

## 2. Create a master table containing the date and close price of all the six stocks. (Column header for the price is the name of the stock)

create table master_stocks (
	`date` date,
	`bajaj` decimal(10,2),
    `tcs` decimal(10,2),
    `tvs` decimal(10,2),
    `infosys` decimal(10,2),
    `eicher` decimal(10,2),
    `hero` decimal(10,2)  
);


-- insert values into master stocks table

insert into master_stocks (date, bajaj, tcs, tvs, infosys, eicher, hero) 
	select bajaj_auto.ano_date, bajaj_auto.`close price`, tcs.`close price`, tvs_motors.`close price`, infosys.`close price`, 
		   eicher_motors.`close price`, hero_motocorp.`close price`	   	   
	from  bajaj_auto
   	inner join tcs on bajaj_auto.ano_date = tcs.ano_date
	inner join tvs_motors on bajaj_auto.ano_date = tvs_motors.ano_date
	inner join infosys on bajaj_auto.ano_date = infosys.ano_date
	inner join eicher_motors on bajaj_auto.ano_date = eicher_motors.ano_date
	inner join hero_motocorp on bajaj_auto.ano_date = hero_motocorp.ano_date
	order by ano_date;
    
-- view the updated master_stocks table
    
select * from master_stocks;

## 3. Use the table created in Part(1) to generate buy and sell signal. Store this in another table named 'bajaj2'. Perform this operation for all stocks.

# bajaj2

create table bajaj2 as
select 
		date_value AS "Date",
		close_price AS "Close Price",
		case when first_value(short_term_greater) over w = nth_value(short_term_greater,2) over w then  'Hold'
				when NTH_VALUE(short_term_greater,2) over w = 'Y' then 'Buy'
				when NTH_VALUE(short_term_greater,2) over w = 'N' then 'Sell'
                else 'Hold'
                end
			
		 AS "Signal" 
	FROM
(
select
		`Date` as date_value,
		`Close Price` AS close_price,
		if(`20 Day MA`>`50 Day MA`,'Y','N') short_term_greater
	from
		bajaj1 
) temp_table
window w as (order by date_value rows between 1 preceding and 0 following);

select * from bajaj2 order by `Date`;

# eicher2

drop table if exists `eicher2`;

create table eicher2 as
select 
		date_value AS "Date",
		close_price AS "Close Price",
		case when first_value(short_term_greater) over w = nth_value(short_term_greater,2) over w then  'Hold'
				when NTH_VALUE(short_term_greater,2) over w = 'Y' then 'Buy'
				when NTH_VALUE(short_term_greater,2) over w = 'N' then 'Sell'
                else 'Hold'
                end
			
		 AS "Signal" 
	FROM
(
select
		`Date` as date_value,
		`Close Price` AS close_price,
		if(`20 Day MA`>`50 Day MA`,'Y','N') short_term_greater
	from
		eicher1 
) temp_table
window w as (order by date_value rows between 1 preceding and 0 following);

select * from eicher2 order by `Date`;

# hero2

drop table if exists `hero2`;

create table hero2 as
select 
		date_value AS "Date",
		close_price AS "Close Price",
		case when first_value(short_term_greater) over w = nth_value(short_term_greater,2) over w then  'Hold'
				when NTH_VALUE(short_term_greater,2) over w = 'Y' then 'Buy'
				when NTH_VALUE(short_term_greater,2) over w = 'N' then 'Sell'
                else 'Hold'
                end
			
		 AS "Signal" 
	FROM
(
select
		`Date` as date_value,
		`Close Price` AS close_price,
		if(`20 Day MA`>`50 Day MA`,'Y','N') short_term_greater
	from
		hero1 
) temp_table
window w as (order by date_value rows between 1 preceding and 0 following);
  
select * from hero2 order by `Date`;

# infosys2

drop table if exists `infosys2`;

create table infosys2 as
select 
		date_value AS "Date",
		close_price AS "Close Price",
		case when first_value(short_term_greater) over w = nth_value(short_term_greater,2) over w then  'Hold'
				when NTH_VALUE(short_term_greater,2) over w = 'Y' then 'Buy'
				when NTH_VALUE(short_term_greater,2) over w = 'N' then 'Sell'
                else 'Hold'
                end
			
		 AS "Signal" 
	FROM
(
select
		`Date` as date_value,
		`Close Price` AS close_price,
		if(`20 Day MA`>`50 Day MA`,'Y','N') short_term_greater
	from
		infosys1 
) temp_table
window w as (order by date_value rows between 1 preceding and 0 following);
  
select * from infosys2 order by `Date`;

# tcs2

drop table if exists `tcs2`;

create table tcs2 as
select 
		date_value AS "Date",
		close_price AS "Close Price",
		case when first_value(short_term_greater) over w = nth_value(short_term_greater,2) over w then  'Hold'
				when NTH_VALUE(short_term_greater,2) over w = 'Y' then 'Buy'
				when NTH_VALUE(short_term_greater,2) over w = 'N' then 'Sell'
                else 'Hold'
                end
			
		 AS "Signal" 
	FROM
(
select
		`Date` as date_value,
		`Close Price` AS close_price,
		if(`20 Day MA`>`50 Day MA`,'Y','N') short_term_greater
	from
		tcs1 
) temp_table
window w as (order by date_value rows between 1 preceding and 0 following);
  
select * from tcs2 order by `Date`;

# tvs2

drop table if exists `tvs2`;

create table tvs2 as
select 
		date_value AS "Date",
		close_price AS "Close Price",
		case when first_value(short_term_greater) over w = nth_value(short_term_greater,2) over w then  'Hold'
				when NTH_VALUE(short_term_greater,2) over w = 'Y' then 'Buy'
				when NTH_VALUE(short_term_greater,2) over w = 'N' then 'Sell'
                else 'Hold'
                end
			
		 AS "Signal" 
	FROM
(
select
		`Date` as date_value,
		`Close Price` AS close_price,
		if(`20 Day MA`>`50 Day MA`,'Y','N') short_term_greater
	from
		tvs1 
) temp_table
window w as (order by date_value rows between 1 preceding and 0 following);
  
select * from tvs2 order by `Date`;

## 4. Create a User defined function, that takes the date as input and returns the signal for that particular day (Buy/Sell/Hold) for the Bajaj stock.

delimiter $$

create function get_signal_for_date( input_date date)
returns varchar(10)
deterministic
begin
declare signal_value varchar(10);
select `Signal` into signal_value 
from bajaj2
where `Date` = input_date;
return signal_value;
end $$
delimiter ;

# date format - yyyy-mm-dd  
# Test function for all three signals
select get_signal_for_date('2015-09-29') as day_signal;  # result - hold
select get_signal_for_date('2015-08-24') as day_signal; # result - sell
select get_signal_for_date('2015-05-18') as day_signal; # result - buy

## Remove ano_date from all tables to have tables as original record

alter table `bajaj_auto`
drop column ano_date;
alter table `eicher_motors`
drop column ano_date;
alter table `hero_motocorp`
drop column ano_date;
alter table `infosys`
drop column ano_date;
alter table `tcs`
drop column ano_date;
alter table `tvs_motors`
drop column ano_date;

