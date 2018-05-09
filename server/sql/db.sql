CREATE TABLE Projects (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Name string NOT NULL
);

CREATE TABLE Users (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Email string NOT NULL,
    Password string NOT NULL
);

CREATE TABLE Days (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Date string NOT NULL,
    Morning string NOT NULL,
    Afternoon string NOT NULL,
    Comments string
);



INSERT INTO Projects (Name) VALUES (
    "Cookie Vocal"
); 
