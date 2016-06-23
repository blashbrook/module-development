-- --------------------------------------------------------

-- 
-- Table structure for table `old_users`
-- 

CREATE TABLE `old_users` (
  `user_id` int(32) NOT NULL,
  `username` varchar(32) NOT NULL,
  `email` varchar(32) NOT NULL,
  `pass` varchar(32) NOT NULL
);

-- 
-- Dumping data for table `old_users`
-- 

INSERT INTO `old_users` VALUES (3, 'mary', 'mary@example.com', 'foo');
INSERT INTO `old_users` VALUES (4, 'joe', 'joe@example.com', 'bar');
INSERT INTO `old_users` VALUES (6, 'fred', 'fred@example.com', 'zoo');
INSERT INTO `old_users` VALUES (7, 'betty', 'betty@example.com', 'baz');
INSERT INTO `old_users` VALUES (8, 'friedrich', 'freidrich@example.com', 'free');
INSERT INTO `old_users` VALUES (9, 'martin', 'martin@example.com', 'aoi');
INSERT INTO `old_users` VALUES (10, 'fozzie', 'fozzie@example.com', 'lii');
INSERT INTO `old_users` VALUES (11, 'steve', 'steve@example.com', 'doi');
