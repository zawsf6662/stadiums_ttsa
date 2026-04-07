-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 07, 2026 at 09:57 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `stadium_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `booking_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `stadiums_id` int(11) DEFAULT NULL,
  `booking_date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `total_price` decimal(10,2) DEFAULT NULL,
  `status` enum('PENDING','PAID','CANCEL') DEFAULT 'PENDING',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`booking_id`, `user_id`, `stadiums_id`, `booking_date`, `start_time`, `end_time`, `total_price`, `status`, `created_at`) VALUES
(58, 1, 29, '2026-04-07', '10:00:00', '13:00:00', 4.00, 'CANCEL', '2026-04-06 17:10:51'),
(59, 1, 29, '2026-04-07', '14:00:00', '17:00:00', 4.00, 'CANCEL', '2026-04-06 17:11:51'),
(60, 1, 29, '2026-04-07', '10:00:00', '13:00:00', 4.00, 'CANCEL', '2026-04-06 17:17:51'),
(63, 1, 29, '2026-04-07', '10:00:00', '12:00:00', 4.00, 'CANCEL', '2026-04-06 19:11:51'),
(64, 1, 29, '2026-04-07', '10:00:00', '12:00:00', 4.00, 'CANCEL', '2026-04-06 19:25:51'),
(65, 1, 29, '2026-04-07', '10:00:00', '12:00:00', 4.00, 'CANCEL', '2026-04-06 19:32:35'),
(66, 1, 29, '2026-04-07', '10:00:00', '12:00:00', 4.00, 'PAID', '2026-04-06 19:36:27'),
(67, 1, 29, '2026-04-07', '12:00:00', '14:00:00', 4.00, 'CANCEL', '2026-04-06 19:42:51');

-- --------------------------------------------------------

--
-- Table structure for table `opening_hours`
--

CREATE TABLE `opening_hours` (
  `id` int(11) NOT NULL,
  `day_name` varchar(20) NOT NULL,
  `open_time` time NOT NULL DEFAULT '10:00:00',
  `close_time` time NOT NULL DEFAULT '22:00:00',
  `is_closed` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `opening_hours`
--

INSERT INTO `opening_hours` (`id`, `day_name`, `open_time`, `close_time`, `is_closed`) VALUES
(1, 'Monday', '10:00:00', '23:00:00', 1),
(2, 'Tuesday', '10:00:00', '23:00:00', 0),
(3, 'Wednesday', '10:00:00', '22:00:00', 0),
(4, 'Thursday', '10:00:00', '22:00:00', 0),
(5, 'Friday', '10:00:00', '23:00:00', 0),
(6, 'Saturday', '08:00:00', '00:00:00', 0),
(7, 'Sunday', '08:00:00', '22:00:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `stadiums`
--

CREATE TABLE `stadiums` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `price_per_hour` decimal(10,2) DEFAULT NULL,
  `status` enum('Available','Occupied') DEFAULT 'Available'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stadiums`
--

INSERT INTO `stadiums` (`id`, `name`, `type`, `price_per_hour`, `status`) VALUES
(1, 'Stadium A (Indoor)', 'Parque', 501.00, 'Available'),
(2, 'Stadium B (Outdoor)', 'Artificial Grass', 800.00, 'Available'),
(29, 'xxxx', 'Indoor', 2.00, 'Available');

-- --------------------------------------------------------

--
-- Table structure for table `stadium_exceptions`
--

CREATE TABLE `stadium_exceptions` (
  `id` int(11) NOT NULL,
  `exception_date` date NOT NULL,
  `open_time` time DEFAULT NULL,
  `close_time` time DEFAULT NULL,
  `is_closed` tinyint(1) DEFAULT 0,
  `reason` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `role` enum('USER','ADMIN') DEFAULT 'USER'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `full_name`, `phone`, `role`) VALUES
(1, '123', '$2a$10$AiEJXrdRRlGUx5ou6FoVKelV1AZ9gXPBb9lBnTr/vDIdyJQwNG9ae', '1 2', '123456789', 'USER'),
(2, '1234', '$2a$10$AiEJXrdRRlGUx5ou6FoVKelV1AZ9gXPBb9lBnTr/vDIdyJQwNG9ae', '1 23', '123456780', 'ADMIN');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`booking_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `bookings_ibfk_2` (`stadiums_id`);

--
-- Indexes for table `opening_hours`
--
ALTER TABLE `opening_hours`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `stadiums`
--
ALTER TABLE `stadiums`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `stadium_exceptions`
--
ALTER TABLE `stadium_exceptions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `booking_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT for table `opening_hours`
--
ALTER TABLE `opening_hours`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `stadiums`
--
ALTER TABLE `stadiums`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `stadium_exceptions`
--
ALTER TABLE `stadium_exceptions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`stadiums_id`) REFERENCES `stadiums` (`id`);

DELIMITER $$
--
-- Events
--
CREATE DEFINER=`root`@`localhost` EVENT `auto_cancel_booking` ON SCHEDULE EVERY 1 MINUTE STARTS '2026-04-06 22:10:51' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE bookings 
  SET status = 'CANCEL' 
  WHERE status = 'PENDING' 
  AND created_at < NOW() - INTERVAL 5 MINUTE$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
