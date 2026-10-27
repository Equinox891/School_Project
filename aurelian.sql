
CREATE TABLE pracownicy (
    id_pracownika     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    imie              VARCHAR(50)  NOT NULL,
    nazwisko          VARCHAR(50)  NOT NULL,
    pesel             CHAR(11)     NOT NULL UNIQUE,
    data_urodzenia    DATE         NOT NULL,
    plec              ENUM('K','M') NOT NULL,
    stanowisko        VARCHAR(60)  NOT NULL,
    telefon           VARCHAR(20),
    email             VARCHAR(100),
    data_zatrudnienia DATE         NOT NULL,
    wynagrodzenie     DECIMAL(10,2) NULL,
    CONSTRAINT chk_prac_pesel CHECK (CHAR_LENGTH(pesel) = 11)
) ENGINE=InnoDB;

CREATE TABLE rodzice (
    id_rodzica  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    imie        VARCHAR(50)  NOT NULL,
    nazwisko    VARCHAR(50)  NOT NULL,
    pesel       CHAR(11)     NOT NULL UNIQUE,
    telefon     VARCHAR(20)  NOT NULL,
    email       VARCHAR(100),
    adres       VARCHAR(255) NOT NULL,
    relacja     ENUM('matka','ojciec','opiekun prawny','inny') NOT NULL,
    CONSTRAINT chk_rodz_pesel CHECK (CHAR_LENGTH(pesel) = 11)
) ENGINE=InnoDB;

CREATE TABLE nauczyciele (
    id_nauczyciela   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_pracownika    INT UNSIGNED NOT NULL UNIQUE,
    tytul_zawodowy   VARCHAR(50),
    specjalizacja    VARCHAR(100),
    stopien_awansu   ENUM('stażysta','kontraktowy','mianowany','dyplomowany') NOT NULL,
    data_certyfikatu DATE NULL,
    CONSTRAINT fk_nauczyciel_pracownik
        FOREIGN KEY (id_pracownika) REFERENCES pracownicy(id_pracownika)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE dzieci (
    id_dziecka     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    imie           VARCHAR(50)  NOT NULL,
    nazwisko       VARCHAR(50)  NOT NULL,
    pesel          CHAR(11)     NOT NULL UNIQUE,
    data_urodzenia DATE         NOT NULL,
    plec           ENUM('D','C') NOT NULL,
    grupa          VARCHAR(30)  NOT NULL,
    data_przyjecia DATE         NOT NULL,
    id_nauczyciela INT UNSIGNED NULL,
    CONSTRAINT chk_dzieci_pesel CHECK (CHAR_LENGTH(pesel) = 11),
    CONSTRAINT fk_dzieci_nauczyciel
        FOREIGN KEY (id_nauczyciela) REFERENCES nauczyciele(id_nauczyciela)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE dzieci_rodzice (
    id_dziecka INT UNSIGNED NOT NULL,
    id_rodzica INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_dziecka, id_rodzica),
    CONSTRAINT fk_dr_dziecko
        FOREIGN KEY (id_dziecka) REFERENCES dzieci(id_dziecka)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_dr_rodzic
        FOREIGN KEY (id_rodzica) REFERENCES rodzice(id_rodzica)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO pracownicy
    (imie, nazwisko, pesel, data_urodzenia, plec, stanowisko, telefon, email, data_zatrudnienia, wynagrodzenie)
VALUES
    ('Anna','Kowalska','80010112345','1980-01-01','K','Dyrektor','600100200','a.kowalska@aurelian.pl','2010-09-01',8500.00),
    ('Maria','Nowak','85020223456','1985-02-02','K','Nauczyciel','600200300','m.nowak@aurelian.pl','2015-09-01',5200.00),
    ('Piotr','Wiśniewski','82030334567','1982-03-03','M','Nauczyciel','600300400','p.wisniewski@aurelian.pl','2016-09-01',5200.00),
    ('Katarzyna','Zielińska','90040445678','1990-04-04','K','Nauczyciel','600400500','k.zielinska@aurelian.pl','2018-09-01',5200.00),
    ('Agnieszka','Lewandowska','87050556789','1987-05-05','K','Nauczyciel','600500600','a.lewandowska@aurelian.pl','2017-09-01',5200.00),
    ('Michał','Dąbrowski','91060667890','1991-06-06','M','Nauczyciel','600600700','m.dabrowski@aurelian.pl','2019-09-01',5100.00),
    ('Beata','Szymańska','88070778901','1988-07-07','K','Nauczyciel','600700800','b.szymanska@aurelian.pl','2014-09-01',5400.00),
    ('Krzysztof','Woźniak','83080889012','1983-08-08','M','Nauczyciel','600800900','k.wozniak@aurelian.pl','2013-09-01',5600.00),
    ('Joanna','Kamińska','92090990123','1992-09-09','K','Nauczyciel','600900100','j.kaminska@aurelian.pl','2020-09-01',5000.00),
    ('Ewa','Zielińska','80011001234','1980-11-10','K','Kucharka','601001200','e.zielinska@aurelian.pl','2018-09-01',3800.00),
    ('Teresa','Mazur','78121112345','1978-12-11','K','Woźna','601102300','t.mazur@aurelian.pl','2012-09-01',3400.00),
    ('Roman','Pawlak','75011223456','1975-01-12','M','Intendent','601203400','r.pawlak@aurelian.pl','2011-09-01',4200.00);

INSERT INTO nauczyciele (id_pracownika, tytul_zawodowy, specjalizacja, stopien_awansu, data_certyfikatu) VALUES
    (2,'mgr','edukacja przedszkolna','mianowany','2015-09-01'),
    (3,'mgr','wychowanie fizyczne','kontraktowy','2016-09-01'),
    (4,'mgr','edukacja przedszkolna','mianowany','2018-09-01'),
    (5,'mgr','logopedia','dyplomowany','2017-09-01'),
    (6,'lic.','edukacja przedszkolna','kontraktowy','2019-09-01'),
    (7,'mgr','pedagogika specjalna','dyplomowany','2014-09-01'),
    (8,'mgr','edukacja przedszkolna','dyplomowany','2013-09-01'),
    (9,'mgr','edukacja artystyczna','stażysta','2020-09-01');

DROP TEMPORARY TABLE IF EXISTS seq;
CREATE TEMPORARY TABLE seq (n INT NOT NULL PRIMARY KEY);
INSERT INTO seq (n)
SELECT a.d + b.d*10 + c.d*100 + 1
FROM (SELECT 0 d UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
      UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
     (SELECT 0 d UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
      UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
     (SELECT 0 d UNION SELECT 1 UNION SELECT 2) c
WHERE a.d + b.d*10 + c.d*100 + 1 <= 150;

INSERT INTO rodzice (imie, nazwisko, pesel, telefon, email, adres, relacja)
SELECT
    CASE WHEN n % 2 = 1
         THEN ELT(1 + (n MOD 6), 'Ewa','Anna','Katarzyna','Magdalena','Joanna','Agnieszka')
         ELSE ELT(1 + (n MOD 6), 'Tomasz','Piotr','Marek','Paweł','Krzysztof','Michał')
    END,
    CASE WHEN n % 2 = 1
         THEN ELT(1 + (n MOD 10), 'Nowak','Kowalska','Wiśniewska','Wójcik','Kowalczyk',
                                 'Kamińska','Lewandowska','Zielińska','Szymańska','Woźniak')
         ELSE ELT(1 + (n MOD 10), 'Nowak','Kowalski','Wiśniewski','Wójcik','Kowalczyk',
                                 'Kamiński','Lewandowski','Zieliński','Szymański','Woźniak')
    END,
    CONCAT(
        LPAD(70 + (n MOD 30), 2, '0'),
        LPAD(1 + (n MOD 12), 2, '0'),
        LPAD(1 + (n MOD 28), 2, '0'),
        LPAD((n * 137) MOD 10000, 4, '0'),
        LPAD((n * 37) MOD 10, 1, '0'),
        (n MOD 10)
    ),
    CONCAT('6', LPAD((n * 7919) MOD 100000000, 8, '0')),
    CONCAT('rodzic', n, '@example.com'),
    CONCAT('ul. Przykładowa ', n, ', 00-', LPAD(100 + (n MOD 900), 3, '0'), ' Warszawa'),
    CASE WHEN n % 2 = 1 THEN 'matka' ELSE 'ojciec' END
FROM seq;

INSERT INTO dzieci (imie, nazwisko, pesel, data_urodzenia, plec, grupa, data_przyjecia, id_nauczyciela)
SELECT
    CASE WHEN n % 2 = 1
         THEN ELT(1 + (n MOD 8), 'Zofia','Julia','Maja','Zuzanna','Hanna','Lena','Alicja','Oliwia')
         ELSE ELT(1 + (n MOD 8), 'Antoni','Jan','Aleksander','Filip','Jakub','Szymon','Kacper','Mikołaj')
    END,
    CASE WHEN n % 2 = 1
         THEN ELT(1 + (n MOD 10), 'Nowak','Kowalska','Wiśniewska','Wójcik','Kowalczyk',
                                 'Kamińska','Lewandowska','Zielińska','Szymańska','Woźniak')
         ELSE ELT(1 + (n MOD 10), 'Nowak','Kowalski','Wiśniewski','Wójcik','Kowalczyk',
                                 'Kamiński','Lewandowski','Zieliński','Szymański','Woźniak')
    END,
    CONCAT(
        LPAD(19 + (n MOD 4), 2, '0'),
        LPAD(1 + (n MOD 12), 2, '0'),
        LPAD(1 + (n MOD 28), 2, '0'),
        LPAD((n * 251) MOD 10000, 4, '0'),
        LPAD((n * 53) MOD 10, 1, '0'),
        (n MOD 10)
    ),
    DATE_ADD('2019-01-01', INTERVAL (n * 5) MOD 1460 DAY),
    CASE WHEN n % 2 = 1 THEN 'D' ELSE 'C' END,
    ELT(1 + (n MOD 8), 'Biedronki','Słoneczka','Pszczółki','Motylki',
                      'Żabki','Krasnoludki','Sowy','Liski'),
    DATE_ADD('2023-09-01', INTERVAL (n MOD 24) MONTH),
    1 + (n MOD 8)
FROM seq;

INSERT INTO dzieci_rodzice (id_dziecka, id_rodzica)
SELECT d.n, d.n - (d.n MOD 2 = 0)
FROM (SELECT n FROM seq WHERE n <= 150) d;

INSERT INTO dzieci_rodzice (id_dziecka, id_rodzica)
SELECT d.n, d.n + (d.n MOD 2 = 1)
FROM (SELECT n FROM seq WHERE n <= 150) d
WHERE d.n + (d.n MOD 2 = 1) <= 150;

SELECT 'pracownicy' AS tabela, COUNT(*) AS liczba FROM pracownicy
UNION ALL SELECT 'nauczyciele', COUNT(*) FROM nauczyciele
UNION ALL SELECT 'rodzice',     COUNT(*) FROM rodzice
UNION ALL SELECT 'dzieci',      COUNT(*) FROM dzieci
UNION ALL SELECT 'dzieci_rodzice', COUNT(*) FROM dzieci_rodzice;