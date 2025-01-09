-- SQL CREATE STATEMENTS

-- Create AirportCode table 
CREATE TABLE AirportCode ( 
    airport_code VARCHAR(10) PRIMARY KEY, 
    airport_name VARCHAR(100) NOT NULL, 
    city VARCHAR(50) NOT NULL, 
    country VARCHAR(50) NOT NULL 
); 

-- Create Aircraft table (using aircraft_tail_number instead of auto-generated ID) 
CREATE TABLE Aircraft ( 
    aircraft_tail_number VARCHAR(20) PRIMARY KEY, 
    aircraft_type VARCHAR(50) NOT NULL, 
    total_first_class_seats INT NOT NULL, 
    total_business_class_seats INT NOT NULL, 
    total_economy_class_seats INT NOT NULL 
); 

-- Create FlightRoute table 
CREATE TABLE FlightRoute ( 
    flight_number VARCHAR(10) PRIMARY KEY, 
    departure_airport_code VARCHAR(10) NOT NULL, 
    arrival_airport_code VARCHAR(10) NOT NULL, 
    FOREIGN KEY (departure_airport_code) REFERENCES AirportCode(airport_code), 
    FOREIGN KEY (arrival_airport_code) REFERENCES AirportCode(airport_code) 
); 

-- Create Payment table (created before Booking due to foreign key reference)
CREATE TABLE Payment ( 
    payment_id INT PRIMARY KEY AUTO_INCREMENT, 
    payment_date DATETIME NOT NULL, 
    amount DECIMAL(10, 2) NOT NULL, 
    payment_method VARCHAR(20), 
    payment_status VARCHAR(20), 
    points_earned INT DEFAULT 0 
); 

-- Create Flight table (linked to FlightRoute and using aircraft_tail_number) 
CREATE TABLE Flight ( 
    flight_id INT PRIMARY KEY AUTO_INCREMENT, 
    flight_number VARCHAR(10) NOT NULL, 
    scheduled_departure_time DATETIME NOT NULL, 
    scheduled_arrival_time DATETIME NOT NULL, 
    aircraft_tail_number VARCHAR(20), 
    FOREIGN KEY (flight_number) REFERENCES FlightRoute(flight_number), 
    FOREIGN KEY (aircraft_tail_number) REFERENCES Aircraft(aircraft_tail_number) 
); 

-- Create Passenger table 
CREATE TABLE Passenger ( 
    passenger_id INT PRIMARY KEY AUTO_INCREMENT, 
    name VARCHAR(100) NOT NULL, 
    email VARCHAR(100) UNIQUE NOT NULL, 
    phone VARCHAR(20), 
    passport_number VARCHAR(50) UNIQUE NOT NULL 
); 

-- Create Booking table 
CREATE TABLE Booking ( 
    booking_id INT PRIMARY KEY AUTO_INCREMENT, 
    booking_date DATETIME NOT NULL, 
    passenger_id INT, 
    flight_id INT, 
    booking_class ENUM('First', 'Business', 'Economy') NOT NULL, 
    booking_status VARCHAR(20) NOT NULL, 
    payment_id INT NOT NULL, 
    FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id), 
    FOREIGN KEY (flight_id) REFERENCES Flight(flight_id), 
    FOREIGN KEY (payment_id) REFERENCES Payment(payment_id) 
); 

-- Create FlightStatus table 
CREATE TABLE FlightStatus ( 
    status_id INT PRIMARY KEY AUTO_INCREMENT, 
    flight_id INT, 
    primary_status ENUM('Scheduled', 'Boarding', 'Departed', 'In Air', 'Landed', 'Cancelled', 'Diverted') NOT NULL, 
    secondary_status ENUM('On Time', 'Delayed', 'Gate Change', 'None') DEFAULT 'None', 
    updated_departure_time DATETIME, 
    updated_arrival_time DATETIME, 
    current_departure_gate VARCHAR(10), 
    current_arrival_gate VARCHAR(10), 
    update_time DATETIME NOT NULL, 
    FOREIGN KEY (flight_id) REFERENCES Flight(flight_id) 
); 

-- Create FrequentFlyer table 
CREATE TABLE FrequentFlyer ( 
    ff_id INT PRIMARY KEY AUTO_INCREMENT, 
    passenger_id INT, 
    points_balance INT DEFAULT 0, 
    membership_tier ENUM('Silver', 'Gold', 'Platinum', 'Diamond'), 
    FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id) 
); 

-- Create CheckIn table (linked to Booking) 
CREATE TABLE CheckIn ( 
    checkin_id INT PRIMARY KEY AUTO_INCREMENT, 
    booking_id INT, 
    checkin_time DATETIME NOT NULL, 
    boarding_pass_number VARCHAR(20) UNIQUE NOT NULL, 
    seat_number VARCHAR(5) NOT NULL, 
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) 
); 

-- SQL INSERT STATEMENTS

INSERT INTO AirportCode (airport_code, airport_name, city, country) 
VALUES
('YUL', 'Montreal-Pierre Elliott Trudeau International Airport', 'Montreal', 'Canada'), 
('YYZ', 'Toronto Pearson International Airport', 'Toronto', 'Canada'), 
('YVR', 'Vancouver International Airport', 'Vancouver', 'Canada'), 
('YOW', 'Ottawa Macdonald-Cartier International Airport', 'Ottawa', 'Canada'), 
('CDG', 'Charles de Gaulle Airport', 'Paris', 'France'), 
('LHR', 'London Heathrow Airport', 'London', 'United Kingdom'), 
('JFK', 'John F. Kennedy International Airport', 'New York', 'United States'), 
('LAX', 'Los Angeles International Airport', 'Los Angeles', 'United States'), 
('HND', 'Tokyo Haneda Airport', 'Tokyo', 'Japan'), 
('DXB', 'Dubai International Airport', 'Dubai', 'United Arab Emirates'),
('FRA', 'Frankfurt Airport', 'Frankfurt', 'Germany');

INSERT INTO FlightRoute (flight_number, departure_airport_code, arrival_airport_code)
VALUES 
('AC101', 'YUL', 'LAX'), 
('AC202', 'YYZ', 'LHR'), 
('AC303', 'YVR', 'JFK'), 
('AC404', 'YUL', 'CDG'), 
('AC505', 'YYZ', 'FRA');

INSERT INTO Aircraft (aircraft_tail_number, aircraft_type, total_first_class_seats, total_business_class_seats, total_economy_class_seats) 
VALUES 
('C-FGHL', 'Boeing 777', 2, 6, 12), 
('C-GHJK', 'Airbus A380', 3, 7, 10), 
('C-ABCD', 'Boeing 737', 0, 5, 15), 
('C-XYZW', 'Airbus A320', 1, 4, 15),  -- Corrected the closing quote
('C-DFGH', 'Airbus A220', 2, 7, 11);

INSERT INTO Flight (flight_id, flight_number, scheduled_departure_time, scheduled_arrival_time, aircraft_tail_number) 
VALUES
(1, 'AC101', '2024-08-10 08:00:00', '2024-08-10 11:00:00', 'C-FGHL'), 
(2, 'AC202', '2024-08-11 09:00:00', '2024-08-11 21:00:00', 'C-GHJK'), 
(3, 'AC303', '2024-08-12 07:00:00', '2024-08-12 15:00:00', 'C-ABCD'), 
(4, 'AC404', '2024-08-13 15:00:00', '2024-08-14 01:00:00', 'C-XYZW'), 
(5, 'AC505', '2024-08-14 09:00:00', '2024-08-14 21:00:00', 'C-DFGH'); 

INSERT INTO FlightStatus (status_id, flight_id, primary_status, secondary_status, updated_departure_time, updated_arrival_time, current_departure_gate, current_arrival_gate, update_time)
VALUES 
(1, 1, 'Landed', 'On Time', '2024-08-10 08:00:00', '2024-08-10 12:00:00', 'A12', 'B22', '2024-08-10 12:05:00'), 
(2, 2, 'Landed', 'Delayed', '2024-08-11 10:00:00', '2024-08-11 20:45:00', 'B15', 'C28', '2024-08-11 22:00:00'), -- Delayed 
(3, 3, 'Landed', 'On Time', '2024-08-12 07:00:00', '2024-08-12 11:00:00', 'C18', 'D30', '2024-08-12 11:05:00'), 
(4, 4, 'Boarding', 'On Time', '2024-08-13 15:00:00', '2024-08-13 19:00:00', 'A14', 'B24', '2024-08-13 14:00:00'), 
(5, 5, 'Scheduled', 'Delayed', '2024-08-14 09:30:00', '2024-08-14 13:30:00', 'B16', 'C26', '2024-08-13 14:00:00'); -- Delayed 

INSERT INTO Passenger (passenger_id, name, email, phone, passport_number) 
VALUES
(1, 'John Doe', 'john.doe@example.com', '123-456-7890', 'A12345678'), 
(2, 'Jane Smith', 'jane.smith@example.com', '234-567-8901', 'B23456789'), 
(3, 'Alice Johnson', 'alice.johnson@example.com', '345-678-9012', 'C34567890'), 
(4, 'Bob Brown', 'bob.brown@example.com', '456-789-0123', 'D45678901'), 
(5, 'Charlie Davis', 'charlie.davis@example.com', '567-890-1234', 'E56789012'), 
(6, 'David Harris', 'david.harris@example.com', '678-901-2345', 'F67890123'), 
(7, 'Eve Taylor', 'eve.taylor@example.com', '789-012-3456', 'G78901234'), 
(8, 'Frank White', 'frank.white@example.com', '890-123-4567', 'H89012345'), 
(9, 'Grace Lee', 'grace.lee@example.com', '901-234-5678', 'I90123456'), 
(10, 'Hannah Scott', 'hannah.scott@example.com', '012-345-6789', 'J01234567'), 
(11, 'Ian Black', 'ian.black@example.com', '234-567-8901', 'K23456789'), 
(12, 'Judy Green', 'judy.green@example.com', '345-678-9012', 'L34567890'), 
(13, 'Kyle Blue', 'kyle.blue@example.com', '456-789-0123', 'M45678901'), 
(14, 'Laura Brown', 'laura.brown@example.com', '567-890-1234', 'N56789012'), 
(15, 'Mike Gold', 'mike.gold@example.com', '678-901-2345', 'O67890123'), 
(16, 'Nina White', 'nina.white@example.com', '789-012-3456', 'P78901234'), 
(17, 'Oscar Red', 'oscar.red@example.com', '890-123-4567', 'Q89012345'), 
(18, 'Paula Yellow', 'paula.yellow@example.com', '901-234-5678', 'R90123456'), 
(19, 'Quincy Gray', 'quincy.gray@example.com', '012-345-6789', 'S01234567'), 
(20, 'Rita Orange', 'rita.orange@example.com', '123-456-7890', 'T12345678'), 
(22, 'Tina Green', 'tina.green@example.com', '345-678-9012', 'V34567890'), 
(23, 'Ursula Pink', 'ursula.pink@example.com', '456-789-0123', 'W45678901'), 
(24, 'Victor Black', 'victor.black@example.com', '567-890-1234', 'X56789012'), 
(25, 'Wendy White', 'wendy.white@example.com', '678-901-2345', 'Y67890123'), 
(26, 'Xander Gray', 'xander.gray@example.com', '789-012-3456', 'Z78901234'), 
(27, 'Yara Red', 'yara.red@example.com', '890-123-4567', 'A23456789'), 
(28, 'Zack Blue', 'zack.blue@example.com', '901-234-5678', 'B34567890'), 
(29, 'Andy Brown', 'andy.brown@example.com', '012-345-6789', 'C45678901'), 
(30, 'Betty Gold', 'betty.gold@example.com', '123-456-7890', 'D56789012'), 
(31, 'Charlie Black', 'charlie.black@example.com', '234-567-8901', 'E56789013'), 
(32, 'Debby White', 'debby.white@example.com', '345-678-9012', 'F67890124'), 
(33, 'Eli Green', 'eli.green@example.com', '456-789-0123', 'G78901235'), 
(34, 'Fay Brown', 'fay.brown@example.com', '567-890-1234', 'H89012346'), 
(35, 'George Yellow', 'george.yellow@example.com', '678-901-2345', 'I90123457'), 
(36, 'Helen Gold', 'helen.gold@example.com', '789-012-3456', 'J01234568'), 
(37, 'Ian Blue', 'ian.blue@example.com', '890-123-4567', 'K23456790'), 
(38, 'Jane Red', 'jane.red@example.com', '901-234-5678', 'L34567891'), 
(39, 'Kevin Gray', 'kevin.gray@example.com', '012-345-6789', 'M45678902'), 
(40, 'Laura White', 'laura.white@example.com', '123-456-7890', 'N56789013'), 
(41, 'Mike Black', 'mike.black@example.com', '234-567-8901', 'O67890124'), 
(42, 'Nina Green', 'nina.green@example.com', '345-678-9012', 'P78901235'), 
(43, 'Oscar Brown', 'oscar.brown@example.com', '456-789-0123', 'Q89012346'), 
(44, 'Paula Yello', 'paula.yello@example.com', '567-890-1234', 'R90123457'), 
(45, 'Quincy Gold', 'quincy.gold@example.com', '678-901-2345', 'S01234568'), 
(46, 'Rita Blue', 'rita.blue@example.com', '789-012-3456', 'T12345679'), 
(47, 'Sam White', 'sam.white@example.com', '890-123-4567', 'U23456790'), 
(48, 'Tina Red', 'tina.red@example.com', '901-234-5678', 'V34567891'), 
(49, 'Ursula Gray', 'ursula.gray@example.com', '012-345-6789', 'W45678902'), 
(50, 'Victor Brown', 'victor.brown@example.com', '123-456-7890', 'X56789013'), 
(51, 'Wendy Green', 'wendy.green@example.com', '234-567-8901', 'Y67890124'), 
(52, 'Wendy Brown', 'wendy.brown@example.com', '235-567-8901', 'Y67770124'), 
(56, 'Betty Red', 'betty.red@example.com', '789-012-3456', 'D56789014'), 
(57, 'Charlie Green', 'charlie.green@example.com', '890-123-4567', 'E67890125'), 
(58, 'Debby Brown', 'debby.brown@example.com', '901-234-5678', 'F78901236'), 
(59, 'Eli Yellow', 'eli.yellow@example.com', '012-345-6789', 'G89012347'), 
(60, 'Fay Gold', 'fay.gold@example.com', '123-456-7890', 'H90123458'), 
(61, 'George Blue', 'george.blue@example.com', '234-567-8901', 'I01234569'), 
(62, 'Helen Red', 'helen.red@example.com', '345-678-9012', 'J12345670'), 
(63, 'Ian Green', 'ian.green@example.com', '456-789-0123', 'K23456791'), 
(64, 'Jane Brown', 'jane.brown@example.com', '567-890-1234', 'L34567892'), 
(65, 'Kevin Yellow', 'kevin.yellow@example.com', '678-901-2345', 'M45678903'), 
(66, 'Laura Gold', 'laura.gold@example.com', '789-012-3456', 'N56789014'), 
(67, 'Mike Blue', 'mike.blue@example.com', '890-123-4567', 'O67890125'), 
(68, 'Nina Red', 'nina.red@example.com', '901-234-5678', 'P78901236'), 
(69, 'Oscar Green', 'oscar.green@example.com', '012-345-6789', 'Q89012347'), 
(70, 'Paula Brown', 'paula.brown@example.com', '123-456-7890', 'R90123458'), 
(71, 'Quincy Yellow', 'quincy.yellow@example.com', '234-567-8901', 'S01234569'), 
(72, 'Rita Pink', 'rita.pink@example.com', '345-678-9012', 'T12345680'), 
(73, 'Sam Black', 'sam.black@example.com', '456-789-0123', 'U23456791'), 
(74, 'Tina White', 'tina.white@example.com', '567-890-1234', 'V34567892'); 
 

INSERT INTO FrequentFlyer (ff_id, passenger_id, points_balance, membership_tier) 
VALUES
(1, 1, 12000, 'Gold'), 
(2, 2, 8000, 'Silver'), 
(3, 4, 15000, 'Platinum'), 
(4, 5, 3000, 'Silver'), 
(5, 6, 5000, 'Gold'), 
(6, 7, 10000, 'Gold'), 
(7, 9, 7500, 'Silver'), 
(8, 10, 25000, 'Diamond'), 
(9, 12, 2000, 'Silver'), 
(10, 13, 1500, 'Silver'), 
(11, 14, 5000, 'Gold'), 
(12, 15, 10000, 'Gold'), 
(13, 17, 7000, 'Silver'), 
(14, 18, 6000, 'Gold'), 
(15, 19, 12000, 'Gold'), 
(16, 20, 9000, 'Gold'), 
(18, 23, 15000, 'Platinum'), 
(19, 24, 8000, 'Silver'), 
(20, 26, 20000, 'Diamond'), 
(22, 28, 4500, 'Silver'), 
(23, 30, 8000, 'Silver'), 
(24, 32, 10000, 'Gold'), 
(25, 33, 12000, 'Gold'), 
(26, 34, 9000, 'Gold'), 
(27, 36, 15000, 'Platinum'), 
(28, 37, 2000, 'Silver'), 
(29, 38, 7000, 'Silver'), 
(30, 40, 11000, 'Gold'), 
(31, 41, 8000, 'Silver'), 
(32, 42, 15000, 'Platinum'), 
(33, 44, 6000, 'Gold'), 
(34, 46, 12000, 'Gold'), 
(35, 47, 10000, 'Gold'), 
(36, 49, 3000, 'Silver'), 
(37, 50, 25000, 'Diamond'), 
(38, 52, 8000, 'Silver'), 
(40, 56, 12000, 'Gold'), 
(41, 58, 15000, 'Platinum'), 
(42, 59, 5000, 'Gold'), 
(43, 60, 4000, 'Silver'), 
(44, 62, 20000, 'Diamond'), 
(45, 63, 10000, 'Gold'); 


INSERT INTO Payment (payment_id, payment_date, amount, payment_method, payment_status, points_earned) 
VALUES 
-- Flight AC101 Payments 
(1, '2024-08-09 10:00:00', 1500.00, 'Credit Card', 'Completed', 150), -- First Class, 150 points earned 
(2, '2024-08-09 10:05:00', 1500.00, 'Credit Card', 'Completed', 150), -- First Class, 150 points earned 
(3, '2024-08-09 10:10:00', 1000.00, 'Credit Card', 'Completed', 100), -- Business, 100 points earned 
(4, '2024-08-09 10:15:00', 1000.00, 'Credit Card', 'Completed', 100), -- Business, 100 points earned 
(5, '2024-08-09 10:20:00', 1000.00, 'Credit Card', 'Completed', 100), -- Business, 100 points earned 
(6, '2024-08-09 10:25:00', 900.00, 'Mix', 'Completed', -10), -- Business, 100 points redeemed ($100), 90 points earned, net -10 points 
(7, '2024-08-09 10:30:00', 1000.00, 'Credit Card', 'Completed', 100), -- Business, 100 points earned 
(8, '2024-08-09 10:35:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(9, '2024-08-09 10:40:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(10, '2024-08-09 10:45:00', 500.00, 'Mix', 'Completed', -50), -- Economy, 100 points redeemed ($100), 50 points earned, net -50 points 
(11, '2024-08-09 10:50:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(12, '2024-08-09 10:55:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(13, '2024-08-09 11:00:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(14, '2024-08-09 11:05:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(15, '2024-08-09 11:10:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(16, '2024-08-09 11:15:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(17, '2024-08-09 11:20:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(18, '2024-08-09 11:25:00', 0.00, 'Points', 'Completed', -600), -- Economy, Fully paid with points, net -600 points 
 
-- Flight AC202 Payments 
(19, '2024-08-10 09:00:00', 1500.00, 'Credit Card', 'Completed', 150), -- First Class, 150 points earned 
(20, '2024-08-10 09:05:00', 1400.00, 'Mix', 'Completed', 40), -- First Class, 100 points redeemed ($100), 140 points earned, net 40 points 
(21, '2024-08-10 09:15:00', 1000.00, 'Credit Card', 'Completed', 100), -- Business, 100 points earned 
(22, '2024-08-10 09:20:00', 1000.00, 'Credit Card', 'Completed', 100), -- Business, 100 points earned 
(23, '2024-08-10 09:25:00', 900.00, 'Mix', 'Completed', -10), -- Business, 100 points redeemed ($100), 90 points earned, net -10 points 
(24, '2024-08-10 09:30:00', 1000.00, 'Credit Card', 'Completed', 100), -- Business, 100 points earned 
(25, '2024-08-10 09:35:00', 1000.00, 'Credit Card', 'Completed', 100), -- Business, 100 points earned 
(26, '2024-08-10 09:40:00', 1000.00, 'Credit Card', 'Completed', 100), -- Business, 100 points earned 
(27, '2024-08-10 09:45:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(28, '2024-08-10 09:50:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(29, '2024-08-10 09:55:00', 500.00, 'Mix', 'Completed', -50), -- Economy, 100 points redeemed ($100), 50 points earned, net -50 points 
(30, '2024-08-10 10:00:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(31, '2024-08-10 10:05:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(32, '2024-08-10 10:10:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(33, '2024-08-10 10:15:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(34, '2024-08-10 10:20:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(35, '2024-08-10 10:25:00', 0.00, 'Points', 'Completed', -600), -- Economy, Fully paid with points, net -600 points 
(36, '2024-08-10 10:30:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
 
-- Flight AC303 Payments 
(37, '2024-08-11 07:00:00', 1000.00, 'Credit Card', 'Completed', 100), -- Business, 100 points earned 
(38, '2024-08-11 07:05:00', 1000.00, 'Credit Card', 'Completed', 100), -- Business, 100 points earned 
(39, '2024-08-11 07:10:00', 1000.00, 'Credit Card', 'Completed', 100), -- Business, 100 points earned 
(40, '2024-08-11 07:15:00', 900.00, 'Mix', 'Completed', -10), -- Business, 100 points redeemed ($100), 90 points earned, net -10 points 
(41, '2024-08-11 07:20:00', 1000.00, 'Credit Card', 'Completed', 100), -- Business, 100 points earned 
(42, '2024-08-11 07:25:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(43, '2024-08-11 07:30:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(44, '2024-08-11 07:35:00', 500.00, 'Mix', 'Completed', -50), -- Economy, 100 points redeemed ($100), 50 points earned, net -50 points 
(45, '2024-08-11 07:40:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(46, '2024-08-11 07:45:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(47, '2024-08-11 07:50:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(48, '2024-08-11 07:55:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(49, '2024-08-11 08:00:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(50, '2024-08-11 08:05:00', 0.00, 'Points', 'Completed', -600), -- Economy, Fully paid with points, net -600 points 
(51, '2024-08-11 08:10:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
 
-- Flight AC404 Payments 
(52, '2024-08-12 15:00:00', 1500.00, 'Credit Card', 'Completed', 150), -- First Class, 150 points earned 
(53, '2024-08-12 15:10:00', 1400.00, 'Mix', 'Completed', 40), -- Business Class, 100 points redeemed ($100), 140 points earned, net 40 points 
(54, '2024-08-12 15:15:00', 1000.00, 'Credit Card', 'Completed', 100), -- Business Class, 100 points earned 
(55, '2024-08-12 15:20:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(56, '2024-08-12 15:25:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(57, '2024-08-12 15:30:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(58, '2024-08-12 15:35:00', 500.00, 'Mix', 'Completed', -50), -- Economy, 100 points redeemed ($100), 50 points earned, net -50 points 
(59, '2024-08-12 15:40:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(60, '2024-08-12 15:45:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(61, '2024-08-12 15:50:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(62, '2024-08-12 15:55:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(63, '2024-08-12 16:00:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(64, '2024-08-12 16:05:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(65, '2024-08-12 16:10:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(66, '2024-08-12 16:15:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(67, '2024-08-12 16:20:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(68, '2024-08-12 16:25:00', 0.00, 'Points', 'Completed', -600), -- Economy, Fully paid with points, net -600 points 
(69, '2024-08-12 16:30:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
 
-- Flight AC505 Payments 
(70, '2024-08-13 09:00:00', 1500.00, 'Credit Card', 'Completed', 150), -- First Class, 150 points earned 
(71, '2024-08-13 09:05:00', 1400.00, 'Mix', 'Completed', 40), -- First Class, 100 points redeemed ($100), 140 points earned, net 40 points 
(72, '2024-08-13 09:10:00', 1000.00, 'Credit Card', 'Completed', 100), -- Business Class, 100 points earned 
(73, '2024-08-13 09:15:00', 1000.00, 'Credit Card', 'Completed', 100), -- Business Class, 100 points earned 
(74, '2024-08-13 09:20:00', 900.00, 'Mix', 'Completed', -10), -- Business Class, 100 points redeemed ($100), 90 points earned, net -10 points 
(75, '2024-08-13 09:25:00', 1000.00, 'Credit Card', 'Completed', 100), -- Business Class, 100 points earned 
(76, '2024-08-13 09:30:00', 1000.00, 'Credit Card', 'Completed', 100), -- Business Class, 100 points earned 
(77, '2024-08-13 09:35:00', 1000.00, 'Credit Card', 'Completed', 100), -- Business Class, 100 points earned 
(78, '2024-08-13 09:40:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(79, '2024-08-13 09:45:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(80, '2024-08-13 09:50:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(81, '2024-08-13 09:55:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(82, '2024-08-13 10:00:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(83, '2024-08-13 10:05:00', 500.00, 'Mix', 'Completed', -50), -- Economy, 100 points redeemed ($100), 50 points earned, net -50 points 
(84, '2024-08-13 10:10:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(85, '2024-08-13 10:15:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(86, '2024-08-13 10:20:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(87, '2024-08-13 10:25:00', 600.00, 'Credit Card', 'Completed', 60), -- Economy, 60 points earned 
(88, '2024-08-13 10:30:00', 0.00, 'Points', 'Completed', -600); -- Economy, Fully paid with points, net -600 points 

 

-- Corrected Flight AC101 Booking Data 
 
INSERT INTO Booking (booking_date, passenger_id, flight_id, booking_class, booking_status, payment_id)
VALUES
-- First Class (2 seats, fully booked) 
('2024-08-09 10:00:00', 1, 1, 'First', 'Confirmed', 1), 
('2024-08-09 10:05:00', 2, 1, 'First', 'Confirmed', 2), 
 
-- Business Class (6 seats, 5 booked, 1 removed) 
('2024-08-09 10:10:00', 3, 1, 'Business', 'Confirmed', 3), 
('2024-08-09 10:15:00', 4, 1, 'Business', 'Confirmed', 4), 
('2024-08-09 10:20:00', 5, 1, 'Business', 'Confirmed', 5), 
('2024-08-09 10:25:00', 6, 1, 'Business', 'Confirmed', 6), 
('2024-08-09 10:30:00', 7, 1, 'Business', 'Confirmed', 7), 
 
-- Economy Class (12 seats, 11 booked, 1 removed) 
('2024-08-09 10:35:00', 8, 1, 'Economy', 'Confirmed', 8), 
('2024-08-09 10:40:00', 9, 1, 'Economy', 'Confirmed', 9), 
('2024-08-09 10:45:00', 10, 1, 'Economy', 'Confirmed', 10), 
('2024-08-09 10:50:00', 11, 1, 'Economy', 'Confirmed', 11), 
('2024-08-09 10:55:00', 12, 1, 'Economy', 'Confirmed', 12), 
('2024-08-09 11:00:00', 13, 1, 'Economy', 'Confirmed', 13), 
('2024-08-09 11:05:00', 14, 1, 'Economy', 'Confirmed', 14), 
('2024-08-09 11:10:00', 15, 1, 'Economy', 'Confirmed', 15), 
('2024-08-09 11:15:00', 16, 1, 'Economy', 'Confirmed', 16), 
('2024-08-09 11:20:00', 17, 1, 'Economy', 'Confirmed', 17), 
('2024-08-09 11:25:00', 18, 1, 'Economy', 'Confirmed', 18); 
 
 

-- Corrected Flight AC202 Booking Data 
 
INSERT INTO Booking (booking_date, passenger_id, flight_id, booking_class, booking_status, payment_id) 
VALUES 
-- First Class (3 seats, 2 booked, 1 removed) 
('2024-08-10 09:00:00', 19, 2, 'First', 'Confirmed', 19), 
('2024-08-10 09:05:00', 20, 2, 'First', 'Confirmed', 20), 
 
-- Business Class (7 seats, 6 booked, 1 removed) 
('2024-08-10 09:15:00', 22, 2, 'Business', 'Confirmed', 22), 
('2024-08-10 09:20:00', 23, 2, 'Business', 'Confirmed', 23), 
('2024-08-10 09:25:00', 24, 2, 'Business', 'Confirmed', 24), 
('2024-08-10 09:30:00', 25, 2, 'Business', 'Confirmed', 25), 
('2024-08-10 09:35:00', 26, 2, 'Business', 'Confirmed', 26), 
('2024-08-10 09:40:00', 27, 2, 'Business', 'Confirmed', 27), 
 
-- Economy Class (10 seats, 9 booked, 1 removed) 
('2024-08-10 09:45:00', 28, 2, 'Economy', 'Confirmed', 28), 
('2024-08-10 09:50:00', 29, 2, 'Economy', 'Confirmed', 29), 
('2024-08-10 09:55:00', 30, 2, 'Economy', 'Confirmed', 30), 
('2024-08-10 10:00:00', 31, 2, 'Economy', 'Confirmed', 31), 
('2024-08-10 10:05:00', 32, 2, 'Economy', 'Confirmed', 32), 
('2024-08-10 10:10:00', 33, 2, 'Economy', 'Confirmed', 33), 
('2024-08-10 10:15:00', 34, 2, 'Economy', 'Confirmed', 34), 
('2024-08-10 10:20:00', 35, 2, 'Economy', 'Confirmed', 35), 
('2024-08-10 10:25:00', 36, 2, 'Economy', 'Confirmed', 36); 
 
 
 

-- Corrected Flight AC303 Booking Data 
 
INSERT INTO Booking (booking_date, passenger_id, flight_id, booking_class, booking_status, payment_id) 
VALUES 
-- Business Class (5 seats, fully booked) 
('2024-08-11 07:00:00', 38, 3, 'Business', 'Confirmed', 37), 
('2024-08-11 07:05:00', 39, 3, 'Business', 'Confirmed', 38), 
('2024-08-11 07:10:00', 40, 3, 'Business', 'Confirmed', 39), 
('2024-08-11 07:15:00', 41, 3, 'Business', 'Confirmed', 40), 
('2024-08-11 07:20:00', 42, 3, 'Business', 'Confirmed', 41), 
 
-- Economy Class (15 seats, 9 booked, 6 removed) 
('2024-08-11 07:25:00', 43, 3, 'Economy', 'Confirmed', 42), 
('2024-08-11 07:30:00', 44, 3, 'Economy', 'Confirmed', 43), 
('2024-08-11 07:35:00', 45, 3, 'Economy', 'Confirmed', 44), 
('2024-08-11 07:40:00', 46, 3, 'Economy', 'Confirmed', 45), 
('2024-08-11 07:45:00', 47, 3, 'Economy', 'Confirmed', 46), 
('2024-08-11 07:50:00', 48, 3, 'Economy', 'Confirmed', 47), 
('2024-08-11 07:55:00', 49, 3, 'Economy', 'Confirmed', 48), 
('2024-08-11 08:00:00', 50, 3, 'Economy', 'Confirmed', 49), 
('2024-08-11 08:05:00', 51, 3, 'Economy', 'Confirmed', 50),
('2024-08-11 08:10:00', 52, 3, 'Economy', 'Confirmed', 51); 
 

-- Corrected Flight AC404 Booking Data 
 
INSERT INTO Booking (booking_date, passenger_id, flight_id, booking_class, booking_status, payment_id)
VALUES 
-- First Class (1 seat, fully booked) 
('2024-08-12 15:00:00', 56, 4, 'First', 'Confirmed', 52), 

-- Business Class (4 seats, 2 booked, 2 open) 
('2024-08-12 15:10:00', 57, 4, 'Business', 'Confirmed', 53), 
('2024-08-12 15:15:00', 58, 4, 'Business', 'Confirmed', 54), 

-- Economy Class (15 seats, fully booked) 
('2024-08-12 15:20:00', 59, 4, 'Economy', 'Confirmed', 55), 
('2024-08-12 15:25:00', 60, 4, 'Economy', 'Confirmed', 56), 
('2024-08-12 15:30:00', 61, 4, 'Economy', 'Confirmed', 57), 
('2024-08-12 15:35:00', 62, 4, 'Economy', 'Confirmed', 58), 
('2024-08-12 15:40:00', 63, 4, 'Economy', 'Confirmed', 59), 
('2024-08-12 15:45:00', 64, 4, 'Economy', 'Confirmed', 60), 
('2024-08-12 15:50:00', 65, 4, 'Economy', 'Confirmed', 61), 
('2024-08-12 15:55:00', 66, 4, 'Economy', 'Confirmed', 62), 
('2024-08-12 16:00:00', 67, 4, 'Economy', 'Confirmed', 63), 
('2024-08-12 16:05:00', 68, 4, 'Economy', 'Confirmed', 64), 
('2024-08-12 16:10:00', 69, 4, 'Economy', 'Confirmed', 65), 
('2024-08-12 16:15:00', 70, 4, 'Economy', 'Confirmed', 66), 
('2024-08-12 16:20:00', 71, 4, 'Economy', 'Confirmed', 67), 
('2024-08-12 16:25:00', 72, 4, 'Economy', 'Confirmed', 68),
('2024-08-12 16:30:00', 73, 4, 'Economy', 'Confirmed', 69);


 

-- Flight AC505 (Boeing 777: 2 First, 6 Business, 12 Economy) 
-- Fully booked 
 
INSERT INTO Booking (booking_date, passenger_id, flight_id, booking_class, booking_status, payment_id) 
VALUES 
('2024-08-13 09:00:00', 74, 5, 'First', 'Confirmed', 70), 
('2024-08-13 09:05:00', 1, 5, 'First', 'Confirmed', 71), 
('2024-08-13 09:10:00', 2, 5, 'Business', 'Confirmed', 72), 
('2024-08-13 09:15:00', 3, 5, 'Business', 'Confirmed', 73), 
('2024-08-13 09:20:00', 4, 5, 'Business', 'Confirmed', 74), 
('2024-08-13 09:25:00', 5, 5, 'Business', 'Confirmed', 75), 
('2024-08-13 09:30:00', 20, 5, 'Business', 'Confirmed', 76), 
('2024-08-13 09:35:00', 33, 5, 'Business', 'Confirmed', 77), 
('2024-08-13 09:40:00', 22, 5, 'Economy', 'Confirmed', 78), 
('2024-08-13 09:45:00', 23, 5, 'Economy', 'Confirmed', 79), 
('2024-08-13 09:50:00', 24, 5, 'Economy', 'Confirmed', 80), 
('2024-08-13 09:55:00', 25, 5, 'Economy', 'Confirmed', 81), 
('2024-08-13 10:00:00', 26, 5, 'Economy', 'Confirmed', 82), 
('2024-08-13 10:05:00', 27, 5, 'Economy', 'Confirmed', 83), 
('2024-08-13 10:10:00', 28, 5, 'Economy', 'Confirmed', 84), 
('2024-08-13 10:15:00', 29, 5, 'Economy', 'Confirmed', 85), 
('2024-08-13 10:20:00', 30, 5, 'Economy', 'Confirmed', 86), 
('2024-08-13 10:25:00', 31, 5, 'Economy', 'Confirmed', 87), 
('2024-08-13 10:30:00', 32, 5, 'Economy', 'Confirmed', 88); 



INSERT INTO CheckIn (booking_id, checkin_time, boarding_pass_number, seat_number) 
VALUES 
(1, '2024-08-10 06:00:00', 'BP123456', '1A'), 
(2, '2024-08-10 06:05:00', 'BP234567', '1B'), 
(3, '2024-08-10 06:10:00', 'BP345670', '2A'), 
(4, '2024-08-10 06:15:00', 'BP450089', '2B'), 
(5, '2024-08-10 06:20:00', 'BP567790', '3A'), 
(6, '2024-08-10 06:25:00', 'BP678901', '3B'), 
(7, '2024-08-10 06:30:00', 'BP789012', '4A'), 
(8, '2024-08-10 06:35:00', 'BP890123', '4B'), 
(9, '2024-08-10 06:40:00', 'BP901234', '5A'), 
(10, '2024-08-10 06:45:00', 'BP012345', '5B'), 
(11, '2024-08-10 06:50:00', 'BP123457', '6A'), 
(12, '2024-08-10 06:55:00', 'BP234568', '6B'), 
(13, '2024-08-10 07:00:00', 'BP345678', '7A'), 
(14, '2024-08-10 07:05:00', 'BP456789', '7B'), 
(17, '2024-08-10 07:10:00', 'BP567890', '8A');


INSERT INTO CheckIn (booking_id, checkin_time, boarding_pass_number, seat_number) 
VALUES 
(19, '2024-08-11 07:00:00', 'BP567880', '1A'), 
(20, '2024-08-11 07:05:00', 'BP678906', '1B'), 
(22, '2024-08-11 07:15:00', 'BP789010', '2A'), 
(23, '2024-08-11 07:20:00', 'BP890120', '2B'), 
(24, '2024-08-11 07:25:00', 'BP901235', '3A'), 
(25, '2024-08-11 07:30:00', 'BP012343', '3B'), 
(26, '2024-08-11 07:35:00', 'BP123454', '3C'), 
(27, '2024-08-11 07:40:00', 'BP234565', '4A'), 
(28, '2024-08-11 07:45:00', 'BP345675', '4B'), 
(29, '2024-08-11 07:50:00', 'BP456784', '5A'), 
(30, '2024-08-11 07:55:00', 'BP567899', '5B'), 
(31, '2024-08-11 08:00:00', 'BP678909', '5C'), 
(32, '2024-08-11 08:05:00', 'BP989018', '6A'),
(36, '2024-08-12 05:00:00', 'BP567895', '6B');


INSERT INTO CheckIn (booking_id, checkin_time, boarding_pass_number, seat_number) 
VALUES 
(37, '2024-08-12 05:05:00', 'BP678903', '2B'), 
(38, '2024-08-12 05:10:00', 'BP789014', '3A'), 
(39, '2024-08-12 05:15:00', 'BP890126', '3B'), 
(40, '2024-08-12 05:20:00', 'BP901239', '4A'), 
(41, '2024-08-12 05:25:00', 'BP012340', '5A'), 
(42, '2024-08-12 05:30:00', 'BP123450', '5B'), 
(43, '2024-08-12 05:35:00', 'BP234560', '6A'), 
(44, '2024-08-12 05:40:00', 'BP345677', '6B'), 
(45, '2024-08-12 05:45:00', 'BP456780', '7A'), 
(46, '2024-08-12 05:50:00', 'BP567891', '7B'), 
(47, '2024-08-12 05:55:00', 'BP678905', '8A');


INSERT INTO CheckIn (booking_id, checkin_time, boarding_pass_number, seat_number)
VALUES 
(52, '2024-08-13 13:00:00', 'BP125452', '1A'), 
(53, '2024-08-13 13:05:00', 'BP235563', '2A'), 
(54, '2024-08-13 13:10:00', 'BP345674', '2B'), 
(55, '2024-08-13 13:15:00', 'BP456785', '3A'), 
(56, '2024-08-13 13:20:00', 'BP567896', '3B'), 
(57, '2024-08-13 13:25:00', 'BP678907', '4A'), 
(58, '2024-08-13 13:30:00', 'BP789018', '4B'), 
(59, '2024-08-13 13:35:00', 'BP890129', '5A'), 
(60, '2024-08-13 13:40:00', 'BP901230', '5B'), 
(61, '2024-08-13 13:45:00', 'BP012341', '6A'), 
(62, '2024-08-13 13:50:00', 'BP123452', '6B');

-- END OF CREATE AND INSERT STATEMENTS