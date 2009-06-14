CREATE TABLE `cards` (
  `id` int(11) NOT NULL auto_increment,
  `number_id` int(11) default NULL,
  `color_id` int(11) default NULL,
  `shading_id` int(11) default NULL,
  `shape_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `number_card_id_fkey` (`number_id`),
  KEY `shading_card_id_fkey` (`shading_id`),
  KEY `color_card_id_fkey` (`color_id`),
  KEY `shape_card_id_fkey` (`shape_id`),
  CONSTRAINT `shape_card_id_fkey` FOREIGN KEY (`shape_id`) REFERENCES `shapes` (`id`),
  CONSTRAINT `color_card_id_fkey` FOREIGN KEY (`color_id`) REFERENCES `colors` (`id`),
  CONSTRAINT `number_card_id_fkey` FOREIGN KEY (`number_id`) REFERENCES `numbers` (`id`),
  CONSTRAINT `shading_card_id_fkey` FOREIGN KEY (`shading_id`) REFERENCES `shadings` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8;

CREATE TABLE `cards_decks` (
  `card_id` int(11) default NULL,
  `deck_id` int(11) default NULL,
  KEY `card_cards_deck_id_fkey` (`card_id`),
  KEY `deck_cards_deck_id_fkey` (`deck_id`),
  CONSTRAINT `deck_cards_deck_id_fkey` FOREIGN KEY (`deck_id`) REFERENCES `decks` (`id`),
  CONSTRAINT `card_cards_deck_id_fkey` FOREIGN KEY (`card_id`) REFERENCES `cards` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cards_games` (
  `card_id` int(11) default NULL,
  `game_id` int(11) default NULL,
  KEY `card_cards_game_id_fkey` (`card_id`),
  KEY `game_cards_game_id_fkey` (`game_id`),
  CONSTRAINT `game_cards_game_id_fkey` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`),
  CONSTRAINT `card_cards_game_id_fkey` FOREIGN KEY (`card_id`) REFERENCES `cards` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `colors` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(30) default NULL,
  `abbrev` varchar(3) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `decks` (
  `id` int(11) NOT NULL auto_increment,
  `game_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

CREATE TABLE `games` (
  `id` int(11) NOT NULL auto_increment,
  `deck_count` int(11) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

CREATE TABLE `numbers` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(30) default NULL,
  `abbrev` varchar(3) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `shadings` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(30) default NULL,
  `abbrev` varchar(3) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `shapes` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(30) default NULL,
  `abbrev` varchar(3) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

INSERT INTO `schema_info` (version) VALUES (9)