-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 14, 2026 at 11:27 PM
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
-- Database: `movieapp`
--

-- --------------------------------------------------------

--
-- Table structure for table `movies`
--

CREATE TABLE `movies` (
  `id` bigint(20) NOT NULL,
  `average_rating` double NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `description` text DEFAULT NULL,
  `genre` varchar(50) NOT NULL,
  `poster_url` varchar(500) DEFAULT NULL,
  `release_year` int(11) NOT NULL,
  `review_count` int(11) NOT NULL,
  `title` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `movies`
--

INSERT INTO `movies` (`id`, `average_rating`, `created_at`, `description`, `genre`, `poster_url`, `release_year`, `review_count`, `title`) VALUES
(1, 0, '2026-04-14 19:50:19.000000', 'High school student Polina is saved from bullying at her new school and makes a deal with the main bully Bars: he must pretend to be her boyfriend and protect her, and she must do everything he says. During this game, the couple develops real feelings, but her family and classmates have reasons to separate the lovers.', 'Romance', 'https://image.tmdb.org/t/p/w500/7wIBfBl2gejt6xHxNSK0reVIm7E.jpg', 2026, 0, 'Your Heart Will Be Broken'),
(2, 0, '2026-04-14 19:50:19.000000', 'Having thwarted Bowser\'s previous plot to marry Princess Peach, Mario and Luigi now face a fresh threat in Bowser Jr., who is determined to liberate his father from captivity and restore the family legacy. Alongside companions new and old, the brothers travel across the stars to stop the young heir\'s crusade.', 'Family', 'https://image.tmdb.org/t/p/w500/eJGWx219ZcEMVQJhAgMiqo8tYY.jpg', 2026, 0, 'The Super Mario Galaxy Movie'),
(3, 2.7, '2026-04-14 19:50:19.000000', 'In the wake of the devastating war against the RDA and the loss of their eldest son, Jake Sully and Neytiri face a new threat on Pandora: the Ash People, a violent and power-hungry Na\'vi tribe led by the ruthless Varang. Jake\'s family must fight for their survival and the future of Pandora in a conflict that pushes them to their emotional and physical limits.', 'Science Fiction', 'https://image.tmdb.org/t/p/w500/cf7hE1ifY4UNbS25tGnaTyyDrI2.jpg', 2025, 3, 'Avatar: Fire and Ash'),
(4, 0, '2026-04-14 19:50:19.000000', 'While working underground to fix a water main, Brooklyn plumbers—and brothers—Mario and Luigi are transported down a mysterious pipe and wander into a magical new world. But when the brothers are separated, Mario embarks on an epic quest to find Luigi.', 'Family', 'https://image.tmdb.org/t/p/w500/qNBAXBIQlnOThrVvA6mA2B5ggV6.jpg', 2023, 0, 'The Super Mario Bros. Movie'),
(5, 0, '2026-04-14 19:50:19.000000', 'Scientists have discovered how to \'hop\' human consciousness into lifelike robotic animals, allowing people to communicate with animals as animals. Animal lover Mabel seizes an opportunity to use the technology, uncovering mysteries within the animal world beyond anything she could have imagined.', 'Animation', 'https://image.tmdb.org/t/p/w500/xjtWQ2CL1mpmMNwuU5HeS4Iuwuu.jpg', 2026, 0, 'Hoppers'),
(6, 5, '2026-04-14 19:50:19.000000', 'Science teacher Ryland Grace wakes up on a spaceship light years from home with no recollection of who he is or how he got there. As his memory returns, he begins to uncover his mission: solve the riddle of the mysterious substance causing the sun to die out. He must call on his scientific knowledge and unorthodox ideas to save everything on Earth from extinction… but an unexpected friendship means he may not have to do it alone.', 'Science Fiction', 'https://image.tmdb.org/t/p/w500/yihdXomYb5kTeSivtFndMy5iDmf.jpg', 2026, 3, 'Project Hail Mary'),
(7, 0, '2026-04-14 19:50:19.000000', 'Brandon Beckett and Agent Zero lead a rescue mission in Venezuela when their friends are taken hostage.', 'Action', 'https://image.tmdb.org/t/p/w500/3T9nAX0jAp0iT18ex25BlZEpRDb.jpg', 2026, 0, 'Sniper: No Nation'),
(8, 0, '2026-04-14 19:50:19.000000', 'When a Category 5 hurricane decimates a coastal town, the storm surge brings devastation, chaos, and something far more frightening onto shore: hungry sharks.', 'Horror', 'https://image.tmdb.org/t/p/w500/adk8weka3O5648g3de4z3y4aE7G.jpg', 2026, 0, 'Thrash'),
(9, 0, '2026-04-14 19:50:19.000000', 'A man living in self-imposed exile on a remote island rescues a young girl from a violent storm, setting off a chain of events that forces him out of seclusion to protect her from enemies tied to his past.', 'Action', 'https://image.tmdb.org/t/p/w500/buPFnHZ3xQy6vZEHxbHgL1Pc6CR.jpg', 2026, 0, 'Shelter'),
(10, 0, '2026-04-14 19:50:19.000000', 'Having found the safety of the Greenland bunker after the comet Clarke decimated the Earth, the Garrity family must now risk everything to embark on a perilous journey across the wasteland of Europe to find a new home.', 'Adventure', 'https://image.tmdb.org/t/p/w500/z2tqCJLsw6uEJ8nJV8BsQXGa3dr.jpg', 2026, 0, 'Greenland 2: Migration'),
(11, 0, '2026-04-14 19:50:19.000000', 'When an elusive thief whose high-stakes heists unfold along the iconic 101 freeway in Los Angeles eyes the score of a lifetime, with hopes of this being his final job, his path collides with a disillusioned insurance broker who is facing her own crossroads. Determined to crack the case, a relentless detective closes in on the operation, raising the stakes even higher.', 'Crime', 'https://image.tmdb.org/t/p/w500/tVvpFIoteRHNnoZMhdnwIVwJpCA.jpg', 2026, 0, 'Crime 101'),
(12, 0, '2026-04-14 19:50:19.000000', 'Rebecca Owens, a recent mortuary science graduate takes a night shift job at River Fields Mortuary. Initially, the job seems straightforward — embalming bodies, completing paperwork, and keeping things tidy. But once Rebecca starts working the night shift, things take a dark turn.', 'Horror', 'https://image.tmdb.org/t/p/w500/72AoFPC5TY4DfJwXXS9rPwPeReD.jpg', 2026, 0, 'The Mortuary Assistant'),
(13, 0, '2026-04-14 19:50:19.000000', 'A small goat with big dreams gets a once-in-a-lifetime shot to join the pros and play roarball, a high-intensity, co-ed, full-contact sport dominated by the fastest, fiercest animals in the world.', 'Animation', 'https://image.tmdb.org/t/p/w500/wfuqMlaExcoYiUEvKfVpUTt1v4u.jpg', 2026, 0, 'GOAT'),
(14, 0, '2026-04-14 19:50:19.000000', 'Reef Hawk, Hollywood\'s poster child since age six, is not okay. When he learns about an extortion plot tied to a mysterious video, Reef preemptively sets out on a redemption tour to make amends, confront his demons, and avoid getting canceled.', 'Comedy', 'https://image.tmdb.org/t/p/w500/kSzcpfbTy2pXHGvrVU2WhQTo6oU.jpg', 2026, 0, 'Outcome'),
(15, 0, '2026-04-14 19:50:19.000000', 'A lonely Frankenstein travels to 1930s Chicago to ask groundbreaking scientist Dr. Euphronious to create a companion for him. The two revive a murdered young woman and The Bride is born. But what ensues is beyond what either of them imagined.', 'Science Fiction', 'https://image.tmdb.org/t/p/w500/lV8YHwGkYZsm6EfIqnhaSz2avKt.jpg', 2026, 0, 'The Bride!'),
(16, 0, '2026-04-14 19:50:19.000000', 'When a new Ghostface killer emerges in the quiet town where Sidney Prescott has built a new life, her darkest fears are realized as her daughter becomes the next target. Determined to protect her family, Sidney must face the horrors of her past to put an end to the bloodshed once and for all.', 'Horror', 'https://image.tmdb.org/t/p/w500/jjyuk0edLiW8vOSnlfwWCCLpbh5.jpg', 2026, 0, 'Scream 7'),
(17, 4.5, '2026-04-14 19:50:19.000000', 'On one last grueling mission during Army Ranger training, a combat engineer must lead his unit in a fight against a giant otherworldly killing machine.', 'Action', 'https://image.tmdb.org/t/p/w500/tlPgDzwIE7VYYIIAGCTUOnN4wI1.jpg', 2026, 2, 'War Machine'),
(18, 0, '2026-04-14 19:50:19.000000', 'Two gangsters and the woman they love try to survive the most dangerous night of their lives. As if that wasn’t enough, there’s one wild ingredient added to the mix: a time machine.', 'Comedy', 'https://image.tmdb.org/t/p/w500/7F0jc75HrSkLVcvOXR2FXAIwuEv.jpg', 2026, 0, 'Mike & Nick & Nick & Alice'),
(19, 0, '2026-04-14 19:50:19.000000', 'A troupe of ballerinas find themselves fighting for survival as they attempt to escape from a remote inn after their bus breaks down on the way to a dance competition.', 'Music', 'https://image.tmdb.org/t/p/w500/znTPnXCK3lEQJgqXCvP7e5FUz6f.jpg', 2026, 0, 'Pretty Lethal'),
(20, 5, '2026-04-14 19:50:19.000000', 'The Demon Slayer Corps are drawn into the Infinity Castle, where Tanjiro, Nezuko, and the Hashira face terrifying Upper Rank demons in a desperate fight as the final battle against Muzan Kibutsuji begins.', 'Animation', 'https://image.tmdb.org/t/p/w500/fWVSwgjpT2D78VUh6X8UBd2rorW.jpg', 2025, 2, 'Demon Slayer: Kimetsu no Yaiba Infinity Castle'),
(21, 0, '2026-04-14 19:50:19.000000', 'A South Korean agent hunts a drug ring in Russia and goes head-to-head with a North Korean operative — pulling both into peril and tangled secrets.', 'Thriller', 'https://image.tmdb.org/t/p/w500/82bX2GK4PhaJQtfkTnfmd2P7erG.jpg', 2026, 0, 'Humint'),
(22, 0, '2026-04-14 19:50:19.000000', 'After cracking the biggest case in Zootopia\'s history, rookie cops Judy Hopps and Nick Wilde find themselves on the twisting trail of a great mystery when Gary De\'Snake arrives and turns the animal metropolis upside down. To crack the case, Judy and Nick must go undercover to unexpected new parts of town, where their growing partnership is tested like never before.', 'Animation', 'https://image.tmdb.org/t/p/w500/oJ7g2CifqpStmoYQyaLQgEU32qO.jpg', 2025, 0, 'Zootopia 2'),
(23, 0, '2026-04-14 19:50:19.000000', 'Hsu-Chuan, who works at a game company, accidentally brings home a broken clay doll from a haunted house while developing a new horror VR game. Unexpectedly, his pregnant wife, Mu-Hua, a cultural relic restorer, develops an obsession with the doll and relentlessly tries to repair it. As strange things begin to happen in the house, Mu-Hua\'s condition deteriorates, and Hsu-Chuan, at his wits\' end, seeks help from a spiritual medium, Ah-Sheng. Meanwhile, the horrifying secret hidden behind the clay doll begins to surface.', 'Horror', 'https://image.tmdb.org/t/p/w500/ifYNeKwpyKUTtjkUExrqTc65L2p.jpg', 2025, 0, 'Mudborn'),
(24, 0, '2026-04-14 19:50:19.000000', 'A misfit group of unwitting high school students stumble upon a cursed object, an ancient Aztec Death Whistle. They discover that blowing the whistle and the terrifying sound it emits will summon their future deaths to hunt them down.', 'Horror', 'https://image.tmdb.org/t/p/w500/eGxPyseSnEZBMJaopGfRUO9HSYx.jpg', 2026, 0, 'Whistle'),
(25, 0, '2026-04-14 19:50:19.000000', 'Macau Police brings the tracking expert police officer out of retirement to help catch a dangerous group of professional thieves.', 'Action', 'https://image.tmdb.org/t/p/w500/e0RU6KpdnrqFxDKlI3NOqN8nHL6.jpg', 2025, 0, 'The Shadow\'s Edge'),
(26, 0, '2026-04-14 19:50:19.000000', 'A graphic portrayal of the last twelve hours of Jesus of Nazareth\'s life.', 'Drama', 'https://image.tmdb.org/t/p/w500/rBM5o2HpmCfDejuIPybI09tkY3V.jpg', 2004, 0, 'The Passion of the Christ'),
(27, 0, '2026-04-14 19:50:19.000000', 'A young woman becomes the guardian of a fallen star, which she must protect from dangerous forces with the help of a brave stranger.', 'Adventure', 'https://image.tmdb.org/t/p/w500/m1Zl07DNYeSyNcz9hf8hDsS2oB5.jpg', 2026, 0, 'Starbright'),
(28, 0, '2026-04-14 19:50:19.000000', 'When James receives a mysterious letter from his lost love Mary, he is drawn to Silent Hill—a once-familiar town now consumed by darkness. As he searches for her, James faces monstrous creatures and unravels a terrifying truth that will push him to the edge of his sanity.', 'Mystery', 'https://image.tmdb.org/t/p/w500/fqAGFN2K2kDL0EHxvJaXzaMUkkt.jpg', 2026, 0, 'Return to Silent Hill'),
(29, 0, '2026-04-14 19:50:19.000000', 'A young woman from the Midwest gets more than she bargained for when she moves to New York to become a writer and ends up as the assistant to the tyrannical, larger-than-life editor-in-chief of a major fashion magazine.', 'Drama', 'https://image.tmdb.org/t/p/w500/8912AsVuS7Sj915apArUFbv6F9L.jpg', 2006, 0, 'The Devil Wears Prada'),
(30, 0, '2026-04-14 19:50:19.000000', 'Trying to escape her past, Millie Calloway accepts a job as a live-in housemaid for the wealthy Nina and Andrew Winchester. But what begins as a dream job quickly unravels into something far more dangerous—a sexy, seductive game of secrets, scandal, and power.', 'Mystery', 'https://image.tmdb.org/t/p/w500/cWsBscZzwu5brg9YjNkGewRUvJX.jpg', 2025, 0, 'The Housemaid'),
(31, 0, '2026-04-14 19:50:19.000000', 'When an oil tycoon and a famous adventurer vanish into the harsh winter of remote northern Alaska, a hand-picked rescue team endeavors to bring them home. What they don’t know is that they are trespassing on The Yeti’s territory, and the elements are the least of their worries.', 'Horror', 'https://image.tmdb.org/t/p/w500/qW22SucWPODisKufindxiI5Frxm.jpg', 2026, 0, 'The Yeti'),
(32, 0, '2026-04-14 19:50:19.000000', 'Gym-freak brat Rocky falls in love with Rani, who comes from a well-educated Bengali family. Being from polar opposite worlds, the two decide to switch their families to adjust to each other\'s cultures and backgrounds and to know if their marriage will survive. Rocky and Rani are trapped in a world where they are united by love but divided by families and the ultimate question is will they fit in?', 'Comedy', 'https://image.tmdb.org/t/p/w500/vTQIqlxUkOuyf2UKhlM2OUaFGKz.jpg', 2023, 0, 'Rocky Aur Rani Kii Prem Kahaani'),
(33, 0, '2026-04-14 19:50:19.000000', 'Will Radford is a top analyst for Homeland Security who tracks potential threats through a mass surveillance program, until one day an attack by an unknown entity leads him to question whether the government is hiding something from him... and from the rest of the world.', 'Science Fiction', 'https://image.tmdb.org/t/p/w500/yvirUYrva23IudARHn3mMGVxWqM.jpg', 2025, 0, 'War of the Worlds'),
(34, 0, '2026-04-14 19:50:19.000000', 'They walked into a haunted house with a history of possession and murder. The victims never came out, but the footage did.', 'Horror', 'https://image.tmdb.org/t/p/w500/750RNSHr25GQcCr2Ws8iSGrHJA9.jpg', 2026, 0, 'The House on Haunted Grounds'),
(35, 0, '2026-04-14 19:50:19.000000', 'Tragedy strikes when Heathcliff falls in love with Catherine Earnshaw, a woman from a wealthy family in 18th-century England.', 'Romance', 'https://image.tmdb.org/t/p/w500/3YBce6dTh1D5oCMITXk2S5QhPt.jpg', 2026, 0, '\"Wuthering Heights\"'),
(36, 1, '2026-04-14 19:50:19.000000', 'A group of friends facing mid-life crises head to the rainforest with the intention of remaking their favorite movie from their youth, only to find themselves in a fight for their lives against natural disasters, giant snakes and violent criminals.', 'Adventure', 'https://image.tmdb.org/t/p/w500/hBxN6dwrANN1ic3a4G9x6JZcR3C.jpg', 2025, 1, 'Anaconda'),
(37, 0, '2026-04-14 19:50:19.000000', 'Moments after surviving an all-out attack from the Le Domas family, Grace discovers she’s reached the next level of the nightmarish game — and this time with her estranged sister Faith at her side. Grace has one chance to survive, keep her sister alive, and claim the High Seat of the Council that controls the world. Four rival families are hunting her for the throne, and whoever wins rules it all.', 'Horror', 'https://image.tmdb.org/t/p/w500/jRf89HVEtBZiSnOXXWDhZOfuTwW.jpg', 2026, 0, 'Ready or Not: Here I Come'),
(38, 0, '2026-04-14 19:50:19.000000', 'Peter Parker is unmasked and no longer able to separate his normal life from the high-stakes of being a super-hero. When he asks for help from Doctor Strange the stakes become even more dangerous, forcing him to discover what it truly means to be Spider-Man.', 'Action', 'https://image.tmdb.org/t/p/w500/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg', 2021, 0, 'Spider-Man: No Way Home'),
(39, 0, '2026-04-14 19:50:19.000000', 'Two colleagues become stranded on a deserted island, the only survivors of a plane crash. On the island, they must overcome past grievances and work together to survive, but ultimately, it\'s a battle of wills and wits to make it out alive.', 'Horror', 'https://image.tmdb.org/t/p/w500/mjkS2iAgWj3ik1DTjvI15nHZ7yl.jpg', 2026, 0, 'Send Help'),
(40, 0, '2026-04-14 19:50:19.000000', 'Officer Shivani Shivaji Roy returns to hunt down those behind the disappearance of young girls, risking everything to bring them back alive.', 'Action', 'https://image.tmdb.org/t/p/w500/dHxLBtHw4InwsVumnthupZYz6NM.jpg', 2026, 0, 'Mardaani 3'),
(41, 0, '2026-04-14 19:50:19.000000', 'Louis, a Flemish writer, decides to isolate himself at the Côte d’Azur, hoping this place will bring him inspiration.', 'Drama', 'https://image.tmdb.org/t/p/w500/4TpBhdaSl5ALHbgeaYOLF8Q3haz.jpg', 2021, 0, 'The Unknown Man'),
(42, 0, '2026-04-14 19:50:19.000000', 'A drifter with a mysterious past arrives in a small town and finds the residents in the grip of a ruthless crime boss and realizes he has to help them.', 'Action', 'https://image.tmdb.org/t/p/w500/tQti9QTf13MfzNpXguijgNh7ojE.jpg', 2026, 0, 'Hellfire'),
(43, 0, '2026-04-14 19:50:19.000000', 'The adventures of a group of explorers who make use of a newly discovered wormhole to surpass the limitations on human space travel and conquer the vast distances involved in an interstellar voyage.', 'Adventure', 'https://image.tmdb.org/t/p/w500/yQvGrMoipbRoddT0ZR8tPoR7NfX.jpg', 2014, 0, 'Interstellar'),
(44, 3.7, '2026-04-14 19:50:19.000000', 'After his estranged son gets embroiled in a Nazi plot, self-exiled gangster Tommy Shelby must return to Birmingham to save his family — and his nation.', 'Crime', 'https://image.tmdb.org/t/p/w500/gRMalasZEzsZi4w2VFuYusfSfqf.jpg', 2026, 3, 'Peaky Blinders: The Immortal Man'),
(45, 0, '2026-04-14 19:50:19.000000', 'Estranged half-brothers Jonny and James reunite after their father\'s mysterious death. As they search for the truth, buried secrets reveal a conspiracy threatening to tear their family apart.', 'Action', 'https://image.tmdb.org/t/p/w500/gbVwHl4YPSq6BcC92TQpe7qUTh6.jpg', 2026, 0, 'The Wrecking Crew'),
(46, 0, '2026-04-14 19:50:19.000000', 'A hole on the wall accidentally connects two women emotionally and physically. Forbidden love, greed, betrayal... what lies beyond the hole? And for how long can they keep covering it up?', 'Drama', 'https://image.tmdb.org/t/p/w500/2neZgVuY7prWIak5hhNKT53Hk0N.jpg', 2026, 0, 'Sundutan'),
(47, 0, '2026-04-14 19:50:19.000000', 'A happily engaged couple is put to the test when an unexpected turn sends their wedding week off the rails.', 'Romance', 'https://image.tmdb.org/t/p/w500/ikcNOWB6Qo1ER1H1BJL6Vf0W22s.jpg', 2026, 0, 'The Drama'),
(48, 0, '2026-04-14 19:50:19.000000', 'In the near future, a detective stands on trial accused of murdering his wife. He has ninety minutes to prove his innocence to the advanced AI Judge he once championed, before it determines his fate.', 'Science Fiction', 'https://image.tmdb.org/t/p/w500/pyok1kZJCfyuFapYXzHcy7BLlQa.jpg', 2026, 0, 'Mercy'),
(49, 0, '2026-04-14 19:50:19.000000', 'In a city overrun by crime, government Agent Lily Chen is forced to choose between her duty and her family when her husband is kidnapped, and she’s blackmailed into assassinating high-level criminals to save him. As she delves deeper into the criminal underworld, Lily’s relentless pursuit of justice unravels a web of corruption, leading to a final, life-altering decision that will change her world forever.', 'Action', 'https://image.tmdb.org/t/p/w500/8Cw8GF9wG63kF8pRRXwOx2kXGt.jpg', 2026, 0, 'Infiltrate'),
(50, 0, '2026-04-14 19:50:19.000000', 'In Santiago, Chile, the schoolteacher Luisa proposes a debate about sex with the parents of her students with the intention of giving classes about sex education to the youngsters.', 'Comedy', 'https://image.tmdb.org/t/p/w500/9Unz4SnlkXg0OAxgiLKZAfu096c.jpg', 2003, 0, 'Sex with Love'),
(51, 0, '2026-04-14 19:50:19.000000', 'Some secrets are better left at the bottom of the ocean. Once she\'s in your house, there is no escape. When a struggling artist pulls a beautiful, unconscious woman from the freezing coastal waters, he thinks he’s performed a miracle. But as she recovers within the walls of his secluded home, a series of unsettling events leads him to a terrifying realization: her presence is no coincidence. She is inextricably linked to the same watery grave that claimed his family years ago.', 'Horror', 'https://image.tmdb.org/t/p/w500/uye25uG7k8r3NNPLyPiKOiRnFRF.jpg', 2026, 0, 'The Deadly Little Mermaid'),
(52, 0, '2026-04-14 19:50:19.000000', 'Dr. Kelson finds himself in a shocking new relationship - with consequences that could change the world as they know it - and Spike\'s encounter with Jimmy Crystal becomes a nightmare he can\'t escape.', 'Horror', 'https://image.tmdb.org/t/p/w500/kK1BGkG3KAvWB0WMV1DfOx9yTMZ.jpg', 2026, 0, '28 Years Later: The Bone Temple'),
(53, 0, '2026-04-14 19:50:19.000000', 'Cast out from his clan, a young Predator finds an unlikely ally in a damaged android and embarks on a treacherous journey in search of the ultimate adversary.', 'Action', 'https://image.tmdb.org/t/p/w500/erTRAi241eYF4K8KoGGOI8kFPox.jpg', 2025, 0, 'Predator: Badlands'),
(54, 0, '2026-04-14 19:50:19.000000', 'As rival gangs, corrupt officials and a ruthless Major Iqbal close in, Hamza\'s mission for his country spirals into a bloody personal war where the line between patriot and monster disappears in the streets of Lyari.', 'Action', 'https://image.tmdb.org/t/p/w500/ov8vrRLZGoXHpYjSY9Vpv1tHJX7.jpg', 2026, 0, 'Dhurandhar: The Revenge'),
(55, 0, '2026-04-14 19:50:19.000000', 'Rey develops her newly discovered abilities with the guidance of Luke Skywalker, who is unsettled by the strength of her powers. Meanwhile, the Resistance prepares to do battle with the First Order.', 'Adventure', 'https://image.tmdb.org/t/p/w500/kOVEVeg59E0wsnXmF9nrh6OmWII.jpg', 2017, 0, 'Star Wars: The Last Jedi'),
(56, 0, '2026-04-14 19:50:19.000000', 'When an unexpected enemy emerges and threatens global safety and security, Nick Fury, director of the international peacekeeping agency known as S.H.I.E.L.D., finds himself in need of a team to pull the world back from the brink of disaster. Spanning the globe, a daring recruitment effort begins!', 'Science Fiction', 'https://image.tmdb.org/t/p/w500/RYMX2wcKCBAr24UyPD7xwmjaTn.jpg', 2012, 0, 'The Avengers'),
(57, 0, '2026-04-14 19:50:19.000000', 'A veil abruptly descends over the busy Shibuya area amid the bustling Halloween crowds, trapping countless civilians inside. Satoru Gojo, the strongest jujutsu sorcerer, steps into the chaos. But lying in wait are curse users and spirits scheming to seal him away. Yuji Itadori, accompanied by his classmates and other top-tier jujutsu sorcerers, enters the fray in an unprecedented clash of curses — the Shibuya Incident. In the aftermath, ten colonies across Japan are transformed into dens of curses in a plan orchestrated by Noritoshi Kamo. As the deadly Culling Game starts, Special Grade sorcerer Yuta Okkotsu is assigned to carry out Yuji\'s execution for his perceived crimes. A compilation movie of Shibuya Incident including the first two episodes of the Culling Games arc.', 'Animation', 'https://image.tmdb.org/t/p/w500/v0s3dx6am0RzfsuK3KdEy8ZoCDs.jpg', 2025, 0, 'JUJUTSU KAISEN: Execution'),
(58, 0, '2026-04-14 19:50:19.000000', 'A group of young explorers investigates an old abandoned hotel, only to encounter a strange supernatural being and a competing group looking for a legendary hidden treasure.', 'Horror', 'https://image.tmdb.org/t/p/w500/stM9N7eJmHKLmFR59JG4tLdN7Wk.jpg', 2026, 0, 'Do Not Enter'),
(59, 0, '2026-04-14 19:50:19.000000', 'Discover the story of Michael Jackson, one of the most influential artists the world has ever known, and his life beyond the music, tracing his journey from the discovery of his extraordinary talent as the lead of the Jackson Five, to the visionary artist whose creative ambition fueled a relentless pursuit to become the biggest entertainer in the world, highlighting both his life off-stage and some of the most iconic performances from his early solo career.', 'Music', 'https://image.tmdb.org/t/p/w500/3Qud19bBUrrJAzy0Ilm8gRJlJXP.jpg', 2026, 0, 'Michael'),
(60, 0, '2026-04-14 20:30:28.000000', 'One Battle After Another follows a former revolutionary living off-grid with his daughter whose quiet life unravels when an old nemesis resurfaces, forcing him back into a dangerous world. Paul Thomas Anderson blends political intrigue, dark comedy, and action into a personal story of resistance and family bonds. Acclaimed for its performances, striking visuals, and Jonny Greenwood’s score, it’s ambitious and thought‑provoking, though some find its pacing uneven.', 'Crime', 'https://mlpnk72yciwc.i.optimole.com/cqhiHLc.IIZS~2ef73/w:350/h:519/q:75/https://bleedingcool.com/wp-content/uploads/2025/04/one_battle_after_another_xxlg.jpg', 2025, 0, 'One battle after another'),
(61, 4.3, '2026-04-14 20:55:58.000000', 'The story of J. Robert Oppenheimer\'s role in the development of the atomic bomb during World War II.', 'Historic', 'https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg', 2023, 3, 'Oppenheimer');

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `id` bigint(20) NOT NULL,
  `comment` text NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `rating` int(11) NOT NULL,
  `movie_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`id`, `comment`, `created_at`, `rating`, `movie_id`, `user_id`) VALUES
(1, '100% worth the watch', '2026-04-14 20:07:05.000000', 5, 20, 2),
(2, 'Outstanding Visuals, but no story progression.', '2026-04-14 20:26:07.000000', 4, 3, 1),
(3, 'Beautiful Visuals', '2026-04-14 20:38:18.000000', 5, 6, 3),
(5, 'expected more, but okay', '2026-04-14 20:40:33.000000', 3, 3, 3),
(6, 'don\'t watch,', '2026-04-14 20:43:03.000000', 1, 36, 3),
(7, 'compelling storytelling', '2026-04-14 20:46:00.000000', 5, 6, 2),
(8, 'this one is my least favorite', '2026-04-14 20:46:49.000000', 1, 3, 2),
(9, 'cool one time watch', '2026-04-14 20:48:37.000000', 4, 17, 2),
(10, 'that was good movie', '2026-04-14 20:50:27.000000', 4, 44, 2),
(11, 'I liked the movie.', '2026-04-14 20:51:39.000000', 5, 17, 3),
(12, 'Peak for an anime.', '2026-04-14 20:52:16.000000', 5, 20, 3),
(13, 'okay that was fair', '2026-04-14 20:52:53.000000', 2, 44, 3),
(14, 'Great space exploration', '2026-04-14 20:58:01.000000', 5, 6, 1),
(15, 'After a long time, it was a nice comeback for a Netflix show', '2026-04-14 20:59:30.000000', 5, 44, 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) NOT NULL,
  `username` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `created_at`, `email`, `password`, `role`, `username`) VALUES
(1, '2026-04-14 19:50:18.000000', 'panth@gmail.com', '$2a$10$OvKcDXQV20XWpJUn3d8ELemmQe4uaY0rXC8PHggnSnpDNiH91IBbK', 'ADMIN', 'panth'),
(2, '2026-04-14 19:50:18.000000', 'jayraj@gmail.com', '$2a$10$qL7n1htFmclKyVzYig.ZbOFm347Qym37v9.sIyQVNuoh1TmanR0uO', 'USER', 'jayraj'),
(3, '2026-04-14 19:50:18.000000', 'humayun@gmail.com', '$2a$10$Nu8plkEwHD1IJXiqnjyPueLNyGJeBNsVMWh7ud3ejmz0EnhFXuCcy', 'USER', 'humayun');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `movies`
--
ALTER TABLE `movies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UKovijrmb7g6cvqvlgr25vb8r98` (`user_id`,`movie_id`),
  ADD KEY `FK87tlqya0rq8ijfjscldpvvdyq` (`movie_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UK_6dotkott2kjsp8vw4d0m25fb7` (`email`),
  ADD UNIQUE KEY `UK_r43af9ap4edm43mmtq01oddj6` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `movies`
--
ALTER TABLE `movies`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `FK87tlqya0rq8ijfjscldpvvdyq` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`id`),
  ADD CONSTRAINT `FKcgy7qjc1r99dp117y9en6lxye` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
