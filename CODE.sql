-- SQL QUERIES 

-- List of Airports with highest passenger traffic: The query returns the list of airports with the highest passenger traffic. The airline can use this insight to determine if extra staff are needed at high traffic airport.  
SELECT ac.airport_code, COUNT(passenger_id) AS total_passengers 
FROM Flight f, Booking b, FlightRoute fr, AirportCode ac 
WHERE b.flight_id = f.flight_id 
AND f.flight_number = fr.flight_number 
AND (ac.airport_code = fr.departure_airport_code OR ac.airport_code = fr.arrival_airport_code) 
GROUP BY airport_code 
ORDER BY total_passengers DESC 
LIMIT 3; 

-- Most Frequent Flight Routes: The query returns the most frequent flight routes. The airline can use this insight and check against demand for specific flight route to see if supply matches demand.
SELECT departure_airport_code, arrival_airport_code, COUNT(flight_id) AS Frequency 
FROM Flight f, FlightRoute fr 
WHERE f.flight_number = fr.flight_number 
GROUP BY departure_airport_code, arrival_airport_code 
ORDER BY Frequency DESC; 

-- Demand (number of passenger) for Each Flight Route: The query returns the demand (as the number of passenger) for specific flight routes. The airline can use this insight for planning flights.

SELECT departure_airport_code, arrival_airport_code, COUNT(passenger_id) AS total_passengers 
FROM Flight f, Booking b, FlightRoute fr 
WHERE b.flight_id = f.flight_id 
AND f.flight_number = fr.flight_number 
GROUP BY departure_airport_code, arrival_airport_code 
ORDER BY total_passengers DESC; 

-- List of top destinations for Frequent Flyer: The query returns the list of destinations for FrequentFlyer. The airline can use this insight for marketing to frequent flyer members. 
 
SELECT arrival_airport_code, COUNT(b.passenger_id) AS num_frequent_flyers 
FROM Flight f, Booking b, FrequentFlyer ff, FlightRoute fr  
WHERE b.flight_id = f.flight_id 
AND ff.passenger_id = b.passenger_id 
AND f.flight_number = fr.flight_number 
GROUP BY arrival_airport_code 
ORDER BY num_frequent_flyers DESC; 

-- Flight Booking Trends by Time of Day: The query returns the flight booking trends by time of day (i.e., during what time of the day that most passengers book tickets). The airline can use this insight to set what time of day to display ads or send out marketing emails.  

SELECT EXTRACT(HOUR FROM booking_date) AS hour, COUNT(booking_id) AS num_bookings 
FROM Booking 
GROUP BY hour 
ORDER BY num_bookings DESC; 

-- Usage Frequency for Each Aircraft Type: The query returns the usage frequency for each aircraft type. The airline can use this insight to determine whether an aircraft is under or over utilized.

SELECT aircraft_type, COUNT(flight_id) AS num_flights 
FROM Flight f, Aircraft a 
WHERE f.aircraft_tail_number = a.aircraft_tail_number 
GROUP BY aircraft_type 
ORDER BY num_flights DESC; 

-- Total Revenue per Class: The query returns the total revenue per class. The airline can use this information for targeted marketing purposes.  
 
SELECT booking_class, sum(amount) 
FROM Booking b, Payment p 
WHERE b.payment_id = p.payment_id 
GROUP BY booking_class 
ORDER BY sum(amount) DESC; 

-- List of Flights with Highest Revenue: The query returns the list of flights with the highest revenue. The airline can use this information, coupling with demand and supply information, to adjust flight scheduling.  

SELECT flight_number, scheduled_departure_time, sum(amount) AS total_revenue 
FROM Flight f, Booking b, Payment p 
WHERE f.flight_id = b.flight_id AND b.payment_id = p.payment_id 
GROUP BY flight_number, scheduled_departure_time 
ORDER BY total_revenue DESC;


-- Percentage of People who did not checkin: The query displays the percentage of people who did not check in to booking for each flight. The airline can use this information to reach out to customers who did not check in. 

SELECT f.flight_number, f.scheduled_departure_time,    
   
(SELECT COUNT(*) from Booking b   
   
where f.flight_id = b.flight_id AND NOT EXISTS (SELECT * FROM CheckIn c where b.booking_id = c.booking_id))*100.0/(SELECT count(*) from Booking b where f.flight_id = b.flight_id) AS "Percentage of People who did not check-in"  
   
FROM Flight f ;

-- Free upgrade for Economy Passenger with Highest Membership: The query finds the highest membership passenger with an economy booking, on a flight with fully booked economy and an empty business class seat. The aim is to identify passengers eligible for a free upgrade.  
SELECT f.flight_number, f.scheduled_departure_time, p.name, p.phone, ff.membership_tier 
FROM Flight f 
INNER JOIN Booking b ON f.flight_id = b.flight_id 
INNER JOIN Passenger p ON b.passenger_id = p.passenger_id 
INNER JOIN FrequentFlyer ff ON ff.passenger_id = p.passenger_id 
WHERE EXISTS    
(
    SELECT f2.flight_id   
    FROM Flight f2    
    INNER JOIN Aircraft a ON f2.aircraft_tail_number = a.aircraft_tail_number  
    WHERE 
        (SELECT COUNT(*) FROM Booking b2 WHERE booking_class = 'Economy' AND f2.flight_id = b2.flight_id) = a.total_economy_class_seats   
        AND 
        (SELECT COUNT(*) FROM Booking b2 WHERE booking_class = 'Business' AND f2.flight_id = b2.flight_id) < a.total_business_class_seats   
        AND f.flight_id = f2.flight_id
)    
AND b.booking_class = 'Economy'
ORDER BY
    CASE    
        WHEN ff.membership_tier = 'Diamond' THEN 1   
        WHEN ff.membership_tier = 'Platinum' THEN 2   
        WHEN ff.membership_tier = 'Gold' THEN 3   
        WHEN ff.membership_tier = 'Silver' THEN 4   
        ELSE 5    
    END   
LIMIT 1; 

-- List of Flights that Depart from 6:00 AM to Noon: This query returns a list of flights that depart during the morning hours from 6 AM to noon. This is useful for operational efficiency, monitoring morning flight frequency and occupancy rates, assessing airport congestion, and adjusting ticket prices dynamically based on flights during peak morning hours. 

SELECT f.flight_id, f.flight_number, f.scheduled_departure_time 
FROM Flight f 
WHERE TIME(f.scheduled_departure_time) BETWEEN '06:00:00' AND '12:00:00'; 

-- List of the frequency of payment methods used: This query returns a list of payment methods, sorted by how frequently passengers use them. This can optimize costs associated with payment processing (e.g. processing fees), form strategic partnerships with payment providers based on usage data, and understand passenger payment preferences which allows the airline to tailor its payment options.

SELECT py.payment_method, COUNT(b.booking_id) AS usage_count 
FROM Payment py 
JOIN Booking b ON py.payment_id = b.payment_id 
GROUP BY py.payment_method 
ORDER BY usage_count DESC; 

-- Five most frequently used arrival gates: This query returns the five most frequently used arrival gates. This will help the operations team to optimize gate utilization (e.g. overuse) by adjusting a balanced gate assignment.

SELECT fs.current_arrival_gate, COUNT(*) AS usage_count 
FROM FlightStatus fs 
GROUP BY fs.current_arrival_gate 
ORDER BY usage_count DESC 
LIMIT 5; 

-- List of flights with the highest number of passengers in economy class: This query returns the list of flights with the highest number of passengers in economy class. This data drives revenue management strategies (e.g. pricing adjustments), fleet and capacity planning (right aircraft), and target economy passengers with relevant offers.   
SELECT f.flight_number, COUNT(b.booking_id) AS economy_passenger_count 
FROM Booking b 
JOIN Flight f ON b.flight_id = f.flight_id 
WHERE b.booking_class = 'Economy' 
GROUP BY f.flight_number 
ORDER BY economy_passenger_count DESC; 

-- List of delayed flights and their updated arrival times: This query returns the list of flights that have been delayed and their updated arrival times. This piece of information is critical for effective passenger communication keeping them informed and operational coordination to manage ground operations, gate assignments, and crew schedules.  

SELECT f.flight_number, fs.secondary_status, fs.updated_arrival_time 
FROM Flight f 
JOIN FlightStatus fs ON f.flight_id = fs.flight_id 
WHERE fs.secondary_status = 'Delayed'; 

-- The number of departures from a specific airport: This query returns the number of departures from a specific airport. This query can be useful to know if we have a capacity problem in one of the airports.

SELECT f.flight_number, f.scheduled_departure_time, f.scheduled_arrival_time, ac.airport_name AS departure_airport, ac2.airport_name AS arrival_airport FROM Flight f  
JOIN FlightRoute fr ON f.flight_number = fr.flight_number JOIN AirportCode ac ON fr.departure_airport_code = ac.airport_code  
JOIN AirportCode ac2 ON fr.arrival_airport_code = ac2.airport_code  
WHERE fr.departure_airport_code = 'YUL'; 

-- List of fully booked flights: This query provides a list of fully booked flights. This prevents overselling, evaluates the need to increase capacity on specific routes (such as larger aircraft or scheduling additional flights), and provides alternative flights or routes to passengers looking for available seats. 
SELECT f.flight_number, a.aircraft_type  
FROM Flight f  
JOIN Aircraft a ON f.aircraft_tail_number = a.aircraft_tail_number  
JOIN Booking b ON f.flight_id = b.flight_id  
GROUP BY f.flight_id, a.total_first_class_seats, a.total_business_class_seats, a.total_economy_class_seats  
HAVING COUNT(CASE WHEN b.booking_class = 'First' THEN 1 END) >= (a.total_first_class_seats) AND COUNT(CASE WHEN b.booking_class = 'Business' THEN 1 END) >= (a.total_business_class_seats) AND COUNT(CASE WHEN b.booking_class = 'Economy' THEN 1 END) >= (a.total_economy_class_seats); 

-- List of FF members who have never used their points: Query to retrieve all passengers who have never used their frequent flyer points. The airline could use this data to send some offers and reminder emails to these customers.
SELECT p.name, p.email, ff.points_balance  
FROM Passenger p  
JOIN FrequentFlyer ff ON p.passenger_id = ff.passenger_id WHERE ff.points_balance > 0 AND p.passenger_id NOT IN ( SELECT DISTINCT b.passenger_id  
FROM Booking b  
JOIN Payment py ON b.payment_id = py.payment_id  
WHERE py.points_earned < 0 ); 

-- List of flights that have a gate change: Query to find flights that have had a gate change. This is important information needed to be shown in the waiting rooms for the customers. 
SELECT f.flight_number, fs.primary_status, fs.current_departure_gate, fs.current_arrival_gate FROM Flight f JOIN FlightStatus fs ON f.flight_id = fs.flight_id WHERE fs.secondary_status = 'Gate Change'; 

-- Total points earned per flight: Query to find the total points earned per flight. The airline can use this information to identify points usage patterns and revise its rewards points policy as needed. 
SELECT f.flight_number, SUM(py.points_earned) AS total_points_earned  
FROM Flight f  
JOIN Booking b ON f.flight_id = b.flight_id  
JOIN Payment py ON b.payment_id = py.payment_id  
GROUP BY f.flight_number; 

-- Contact information of the top 5 FF members to reach out for promotion.
SELECT p.name, p.email, f.points_balance 
FROM Passenger p 
JOIN FrequentFlyer f ON p.passenger_id = f.passenger_id 
ORDER BY f.points_balance DESC 
LIMIT 5; 

-- Average points by tier of membership: This can help us decide how many miles certain rewards cost.
SELECT f.membership_tier, AVG(f.points_balance) AS avg_points 
FROM FrequentFlyer f 
GROUP BY f.membership_tier  
ORDER BY avg_points DESC; 

-- Retrieve passengers who have made more than 1 booking: The airline can use this information to identify potential members for their frequent flyer program and market this program towards them.
SELECT p.name, p.email, COUNT(b.booking_id) AS total_bookings 
FROM Passenger p 
JOIN Booking b ON p.passenger_id = b.passenger_id 
GROUP BY p.passenger_id 
HAVING total_bookings > 1; 

-- List of flights that have more than 50% of seats booked. This can help change pricing rules for the last half of the seats remaining.
SELECT 
    f.flight_number, 
    COUNT(b.booking_id) AS booked_seats,
    (SELECT a.total_first_class_seats + a.total_business_class_seats + a.total_economy_class_seats 
     FROM Aircraft a 
     WHERE a.aircraft_tail_number = f.aircraft_tail_number
     LIMIT 1) AS total_seats
FROM 
    Flight f 
JOIN 
    Booking b ON f.flight_id = b.flight_id 
GROUP BY 
    f.flight_number, f.aircraft_tail_number
HAVING 
    booked_seats > 0.5 * total_seats; 

-- List of flights that were delayed but still arrived on or before time: This can help us find flights which actually arrive late at their destination. Allowing us to compensate the right passengers for causing delays.
SELECT f.flight_number, s.updated_departure_time, f.scheduled_arrival_time,s.updated_arrival_time 
FROM FlightStatus s 
JOIN Flight f ON s.flight_id = f.flight_id 
WHERE s.secondary_status = 'Delayed'AND s.updated_arrival_time <= f.scheduled_arrival_time;