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
    ID_Users INTEGER NOT NULL,
    Date string NOT NULL,
    Morning string NOT NULL,
    Afternoon string NOT NULL,
    Comments string,
    FOREIGN KEY(ID_Users) REFERENCES Users(ID)
);

CREATE TABLE Projects_On_Days (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Heures INTEGER NOT NULL,
    ID_Users INTEGER NOT NULL,
    ID_Date INTEGER NOT NULL,
    ID_Projects INTEGER NOT NULL,
    FOREIGN KEY(ID_Users) REFERENCES Users(ID),
    FOREIGN KEY(ID_Date) REFERENCES Days(ID),
    FOREIGN KEY(ID_Projects) REFERENCES Projects(ID)
);


INSERT INTO Projects (Name) VALUES (
    "Cookie Vocal"
); 
