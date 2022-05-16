/* Runthrough the backgroung
A crime has taken place and the detective needs your help. The detective gave you the crime scene report, 
but you somehow lost it. You vaguely remember that the crime was a ​murder​ that occurred sometime on ​
Jan.15, 2018​ and that it took place in ​SQL City​. 
*/

/* We'll start by exploring the database using given facts */
SELECT * 
FROM crime_scene_report

/*Observe the date pattern, type and case structure of the SQL City to filter the above query more effecintly */

SELECT * 
FROM crime_scene_report
WHERE date = '20180115' AND type = 'murder' AND city = 'SQL City'

/* THE DESCRIPTION:
Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". 
The second witness, named Annabel, lives somewhere on "Franklin Ave".
*/

/* To know about the witnesses use the given details */

/*For Witness 1*/
SELECT id, name, address_number, address_street_name as address 
FROM person
WHERE address = "Northwestern Dr"
ORDER BY address_number desc limit(1) --Since the person lives in the last house of the street

/* {id:14887, name:Morty Schapiro, address_number:4919, address_street_name:Northwestern Dr}/*

/* For Witness 2*/
SELECT id, name, address_number, address_street_name as address 
FROM person
WHERE name like "%Annabel%" AND address_street_name = "Franklin Ave"        

/* {id:16371, name:Annabel Miller, address_number:103, address_street_name:Franklin Ave} */

/*Now we'll interview both these witnesses and read their transcripts */

SELECT *, person.id, person.name
FROM interview join person
on interview.person_id = person.id
where person_id = 14887 or person_id = 16371

/*
Morty said: I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". 
Only gold members have those bags. The man got into a car with a plate that included "H42W".
Annabel said: I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.
*/

/* On the basis of the statements given by the witnesses, we affirm the furthr details to find the correct suspect */
SELECT person_id, name
FROM get_fit_now_member
LEFT JOIN get_fit_now_check_in ON get_fit_now_member.id = get_fit_now_check_in.membership_id
WHERE membership_status = 'gold' -- Only gold members have those bags
AND id like '%48Z%' -- membership number on the bag started with "48Z"
AND check_in_date = '20180109' -- Witness 2 recognized him on January the 9th

/* To finally catch the murder between these two suspects, we further investigate his license details */
SELECT person.id, name, license_id, drivers_license.plate_number
FROM person join drivers_license
ON person.license_id = drivers_license.id
where person.id = 28819 OR person.id = 67318

/* Here, we got our murderer 'Jeremy Bowers' */

INSERT INTO solution VALUES (1, 'Jeremy Bowers');
        SELECT value FROM solution;

/*
Congrats, you found the murderer! But wait, there's more... If you think you're up for a challenge, try querying the interview 
transcript of the murderer to find the real villain behind this crime.
*/

/* FURTHER INVESTIGATION */
SELECT *
FROM interview
WHERE person_id = 67318

/*
Murderer's transcript: I was hired by a woman with a lot of money. I don't know her name but 
I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. 
I know that she attended the SQL Symphony Concert 3 times in December 2017.
*/
 
/*Fitting in all the relevant in the query to get the women planner behind the murder */
select *
From drivers_license 
join person
on drivers_license.id = person.license_id
join facebook_event_checkin
on person.id = facebook_event_checkin.person_id
where hair_color = "red" and gender = "female" and height >= 65 
and car_make = "Tesla" and car_model = "Model S"         

/*To check the correct answer*/
INSERT INTO solution VALUES (1, 'Miranda Priestly')
SELECT value FROM solution

/* Congrats, you found the brains behind the murder! Everyone in SQL City hails you as the greatest SQL detective of all time. 
Time to break out the champagne! */
