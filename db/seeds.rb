Namespace.create(name: "Global")
User.create(email: "user@example.com")


# create data for mysql
conn = Mysql2::Client.new({ host: "127.0.0.1", port: 3306, username: "root" })
conn.query('DROP DATABASE IF EXISTS `deep_thought_test`;')
conn.query('CREATE DATABASE `deep_thought_test`;')
conn.query('CREATE TABLE `deep_thought_test`.`users` ( `id` INT NOT NULL AUTO_INCREMENT, `name` VARCHAR(45) NULL, PRIMARY KEY (`id`));')
conn.query('use `deep_thought_test`;')
conn.query("INSERT INTO `users` (`name`) values (\"allan\");")
conn.query("INSERT INTO `users` (`name`) values (\"alessandra\");")
conn.close
