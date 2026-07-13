-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 10, 2026 at 02:22 PM
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
-- Database: `hospital_management`
--

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `appointment_id` int(11) NOT NULL,
  `pid` int(11) NOT NULL,
  `did` int(11) NOT NULL,
  `disease_id` int(11) NOT NULL,
  `slot` varchar(20) NOT NULL,
  `appointment_time` time NOT NULL,
  `appointment_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`appointment_id`, `pid`, `did`, `disease_id`, `slot`, `appointment_time`, `appointment_date`) VALUES
(1, 1, 1, 1, 'evening', '21:20:00', '2026-05-08'),
(2, 2, 1, 2, 'morning', '09:00:00', '2026-05-08'),
(3, 3, 2, 1, 'evening', '15:30:00', '2026-05-08'),
(4, 4, 3, 3, 'morning', '10:00:00', '2026-05-08'),
(5, 5, 4, 1, 'morning', '17:27:00', '2026-05-08'),
(6, 6, 5, 2, 'evening', '16:25:00', '2026-05-08'),
(7, 7, 4, 4, 'morning', '08:30:00', '2026-05-08'),
(8, 8, 5, 2, 'evening', '15:46:00', '2026-05-08'),
(9, 9, 1, 5, 'evening', '15:48:00', '2026-05-08'),
(10, 10, 1, 1, 'Evening', '12:00:00', '2026-03-02'),
(11, 11, 5, 1, 'Morning', '11:41:00', '2026-04-06'),
(12, 12, 8, 4, 'Night', '11:59:00', '2026-06-09');

-- --------------------------------------------------------

--
-- Table structure for table `audit`
--

CREATE TABLE `audit` (
  `tid` int(11) NOT NULL,
  `pid` int(11) NOT NULL,
  `action` varchar(50) NOT NULL,
  `timestamp` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit`
--

INSERT INTO `audit` (`tid`, `pid`, `action`, `timestamp`) VALUES
(1, 10, 'PATIENT INSERTED', '2026-06-05 08:27:01'),
(2, 11, 'PATIENT INSERTED', '2026-06-06 11:41:27'),
(3, 12, 'PATIENT INSERTED', '2026-06-06 12:12:06');

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `tid` int(11) NOT NULL,
  `pid` int(11) DEFAULT NULL,
  `action` varchar(200) NOT NULL,
  `timestamp` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `dept_id` int(11) NOT NULL,
  `dept_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`dept_id`, `dept_name`) VALUES
(3, 'Anesthesiologists'),
(12, 'Anesthesiology'),
(1, 'Cardiologists'),
(6, 'Cardiology'),
(2, 'Dermatologists'),
(9, 'Dermatology'),
(4, 'Endocrinologists'),
(13, 'Endocrinology'),
(15, 'General Medicine'),
(5, 'Medicine'),
(7, 'Neurology'),
(14, 'Oncology'),
(11, 'Ophthalmology'),
(8, 'Orthopedics'),
(10, 'Pediatrics');

-- --------------------------------------------------------

--
-- Table structure for table `diseases`
--

CREATE TABLE `diseases` (
  `disease_id` int(11) NOT NULL,
  `disease_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `diseases`
--

INSERT INTO `diseases` (`disease_id`, `disease_name`) VALUES
(1, 'cold'),
(4, 'diabetes'),
(2, 'fever'),
(3, 'headache'),
(5, 'hypertension');

-- --------------------------------------------------------

--
-- Table structure for table `doctors`
--

CREATE TABLE `doctors` (
  `did` int(11) NOT NULL,
  `email` varchar(50) NOT NULL,
  `doctorname` varchar(50) NOT NULL,
  `dept_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctors`
--

INSERT INTO `doctors` (`did`, `email`, `doctorname`, `dept_id`) VALUES
(1, 'saddam.hossain@gmail.com', 'Saddam Hossain', 1),
(2, 'sadman.islam@gmail.com', 'Sadman Islam', 2),
(3, 'jakaria.ahmed@gmail.com', 'Jakaria Ahmed', 3),
(4, 'sumaiya.khanam@gmail.com', 'Sumaiya Khanam', 4),
(5, 'israt.jahan@gmail.com', 'Israt Jahan', 5),
(6, 'sadman@gmail.com', 'md.shadman islam', 3),
(8, 'kayes@gmail.com', 'Md. Kayes', 3);

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE `patients` (
  `pid` int(11) NOT NULL,
  `email` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `gender` varchar(20) NOT NULL,
  `number` varchar(14) NOT NULL,
  `phone` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`pid`, `email`, `name`, `gender`, `number`, `phone`) VALUES
(1, 'saddam.hossain@gmail.com', 'Saddam Hossain', 'Male', '01711234567', NULL),
(2, 'rafiqul.islam@gmail.com', 'Rafiqul Islam', 'Male', '01819876543', NULL),
(3, 'sadman.islam@gmail.com', 'Sadman Islam', 'Male', '01612345678', NULL),
(4, 'jakaria.ahmed@gmail.com', 'Jakaria Ahmed', 'Male', '01912345678', NULL),
(5, 'sumaiya.khanam@gmail.com', 'Sumaiya Khanam', 'Female', '01521234567', NULL),
(6, 'israt.jahan@gmail.com', 'Israt Jahan', 'Female', '01734567890', NULL),
(7, 'nasrin.akter@gmail.com', 'Nasrin Akter', 'Female', '01812345670', NULL),
(8, 'mostofa.kamal@gmail.com', 'Mostofa Kamal', 'Male', '01987654321', NULL),
(9, 'farida.begum@gmail.com', 'Farida Begum', 'Female', '01611223344', NULL),
(10, '123rocky@gmail.com', 'Md. Rocky', 'Male', '01782358960', NULL),
(11, 'Israt@gmail.com', 'israt jahan', 'Female', '01784398547', NULL),
(12, 'jak@gmail.com', 'Jakaria', 'Male', '01784398547', NULL);

--
-- Triggers `patients`
--
DELIMITER $$
CREATE TRIGGER `patient_delete` BEFORE DELETE ON `patients` FOR EACH ROW BEGIN
    INSERT INTO audit(pid, action, timestamp)
    VALUES(OLD.pid, 'PATIENT DELETED', NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `patient_insertion` AFTER INSERT ON `patients` FOR EACH ROW BEGIN
    INSERT INTO audit(pid, action, timestamp)
    VALUES(NEW.pid, 'PATIENT INSERTED', NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `patient_update` AFTER UPDATE ON `patients` FOR EACH ROW BEGIN
    INSERT INTO audit(pid, action, timestamp)
    VALUES(NEW.pid, 'PATIENT UPDATED', NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `usertype` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `usertype`, `email`, `password`) VALUES
(1, 'saddam', 'Doctor', 'saddam.hossain@gmail.com', 'pbkdf2:sha256:150000$xAKZCiJG$4c7a7e704708f86659d730565ff92e8327b01be5c49a6b1ef8afdf1c531fa5c3'),
(2, 'sumaiya', 'Patient', 'sumaiya.khanam@gmail.com', 'pbkdf2:sha256:150000$Yf51ilDC$028cff81a536ed9d477f9e45efcd9e53a9717d0ab5171d75334c397716d581b8'),
(3, 'israt', 'Patient', 'israt.jahan@gmail.com', 'pbkdf2:sha256:150000$BeSHeRKV$a8b27379ce9b2499d4caef21d9d387260b3e4ba9f7311168b6e180a00db91f22'),
(4, 'Saddam', 'Patient', 'sh6481511@gmail.com', 'scrypt:32768:8:1$btR7aSjxsd9gx5ex$1fe0a172cb70c6991e278daa5a782fbcfa2cda21f8da17f6a558abceea40bb59fc7b4ee08b5c619a1f568fa5d37748e1a1ad39b7edd9544749278dc92d67fb39'),
(5, 'Md. Rocky', 'Patient', '123rocky@gmail.com', 'scrypt:32768:8:1$iDOzdoniTjpEVFE9$ce67c93ba53e85ac1a5c7177b846fd3400bcae3ae36a482398845f94d32f312926611eb8f1791c8f5671ff6aacd91bd763b50a024712e802ff31b964105818d5'),
(6, 'Md.korban', 'Doctor', '12korban@gmail.com', 'scrypt:32768:8:1$WCLRZswHWRfV9we9$5b8778f12316c724f697d792b0a283d81ed585e7d4d32609c6d1a64ab364b58fd084d52dd09d637d3c765aeb14792edb490b4463a1bcb392b36d14e127dfb63a'),
(7, 'Md. Kayes', 'Doctor', 'kayes@gmail.com', 'scrypt:32768:8:1$Ycz5dGrhL6LS0I5i$782285365ef7de5d234dab2e9dcb46ab0c72a231ab17b0d4ca4adb4e18eae3f738dd38d36fa938f376665b8bb0fd9a8065ff1fa448a8e75c27863880f9ab3c12'),
(8, 'israt jahan', 'Patient', 'Israt@gmail.com', 'scrypt:32768:8:1$bUruCq26GTKrgjtm$db3b9c059b58563e864044dd45eadc6be8df1b9592b46b0003163149b08118e4d7b251aef5bd537cf33aa03a68205ca1f01b122be962e9bf73d8cc8a56bb7752'),
(9, 'Jakaria', 'Patient', 'jak@gmail.com', 'scrypt:32768:8:1$bytXfZm0YTUWPczN$f89b01834f5b88311d42e167e1cec3034ac39464681177c15b5f7a901353187046f9e0cb3797e81f50622c3e38ebe1e011e731d28ea01f5a052df7e2f57a271e'),
(10, 'tamin', 'Patient', 'tamin@gmail.com', 'scrypt:32768:8:1$tdb8U8xL4Dn65ins$8165797ddd512013f82dfad54d5ea4ef2337051aadf3a91d70aa3f5a67711c9fab01e67b2686bcfaa121abd43ba9fa53cf37a132ab57739ad40668b4932e04af'),
(11, 'rayhan', 'Patient', 'rayhan@gmail.com', 'scrypt:32768:8:1$CMjb8GfMs8p3vK1N$840d226d81daf05c7a205216236daa31ee6810e32c3a6bb11cec1c01eec41fea40e8b5b2f5013c78ec29d62c1dac70995567cfee122ecb200e5c80950441ff23');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`appointment_id`),
  ADD KEY `pid` (`pid`),
  ADD KEY `did` (`did`),
  ADD KEY `disease_id` (`disease_id`);

--
-- Indexes for table `audit`
--
ALTER TABLE `audit`
  ADD PRIMARY KEY (`tid`),
  ADD KEY `pid` (`pid`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`tid`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`dept_id`),
  ADD UNIQUE KEY `dept_name` (`dept_name`);

--
-- Indexes for table `diseases`
--
ALTER TABLE `diseases`
  ADD PRIMARY KEY (`disease_id`),
  ADD UNIQUE KEY `disease_name` (`disease_name`);

--
-- Indexes for table `doctors`
--
ALTER TABLE `doctors`
  ADD PRIMARY KEY (`did`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `dept_id` (`dept_id`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`pid`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `appointment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `audit`
--
ALTER TABLE `audit`
  MODIFY `tid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `tid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `dept_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `diseases`
--
ALTER TABLE `diseases`
  MODIFY `disease_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `doctors`
--
ALTER TABLE `doctors`
  MODIFY `did` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `pid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `patients` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`did`) REFERENCES `doctors` (`did`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `appointments_ibfk_3` FOREIGN KEY (`disease_id`) REFERENCES `diseases` (`disease_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `audit`
--
ALTER TABLE `audit`
  ADD CONSTRAINT `audit_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `patients` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `doctors`
--
ALTER TABLE `doctors`
  ADD CONSTRAINT `doctors_ibfk_1` FOREIGN KEY (`dept_id`) REFERENCES `departments` (`dept_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
