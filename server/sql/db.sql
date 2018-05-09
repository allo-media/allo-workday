CREATE TABLE Projects (
    ID int NOT NULL PRIMARY KEY,
    Name string NOT NULL
);

CREATE TABLE Users (
    ID int NOT NULL PRIMARY KEY,
    Email string NOT NULL,
    Password string NOT NULL
);

CREATE TABLE day (
    ID int NOT NULL PRIMARY KEY,
    Date string NOT NULL,
    Morning string NOT NULL,
    Afternoon string NOT NULL,
    Comments string
);



INSERT INTO Projects VALUES (
    1,
    "Cookie Vocal"
); 
