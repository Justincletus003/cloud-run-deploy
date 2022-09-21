package main

import (
    "fmt"
    "log"
    "net/http"
    "os"
    "database/sql"
    
    _ "github.com/go-sql-driver/mysql"
    "github.com/golang-migrate/migrate/v4/database/mysql"
)

func main() {
    fmt.Print("Starting server")
    http.HandleFunc("/", handler)
    port := os.Getenv("PORT")
    if port == "" {
        port = "8080"
    }
    log.Printf("listening on port %s", port)
    if err := http.ListenAndServe(":"+port, nil); err != nil {
        log.Fatal(err) 
    }    
    
}

func handler(w http.ResponseWriter, r *http.Request){
    
    user := os.Getenv("user")
    if user == "" {
        w.WriteHeader(http.StatusInternalServerError)
        fmt.Fprintln(w, "username is not empty")
        return
    }

    password := os.Getenv("password")
    if user == "" {
        w.WriteHeader(http.StatusInternalServerError)
        fmt.Fprintln(w, "password is not empty")
        return
    }

    dbname := os.Getenv("dbname")
    if user == "" {
        w.WriteHeader(http.StatusInternalServerError)
        fmt.Fprintln(w, "dbname is not empty")
        return
    }
    

    host := "/cloudsql/pantheon-lighthouse-poc:us-central1:lighthousedb"

    dbURI := fmt.Sprintf("%s:%s@unix(/%s)/%s?multiStatements=true", user, password, host, dbname)

    db, err := sql.Open("mysql", dbURI)
    if err != nil {
        w.WriteHeader(http.StatusInternalServerError)
        w.Write([]byte(err.Error()))
        return
    }


    // // db, _ := sql.Open("mysql", "user:password@tcp(host:port)/dbname?multiStatements=true")
    _, err = mysql.WithInstance(db, &mysql.Config{})

    if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }

    // m, _ := migrate.NewWithDatabaseInstance(
    //     "file:///migrations",
    //     "mysql", 
    //     driver,
    // )
    
    // m.Steps(2)
    w.WriteHeader(http.StatusOK)
    fmt.Fprintln(w, "database successfully connected")
}
