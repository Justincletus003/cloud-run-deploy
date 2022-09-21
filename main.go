package main

import (
    "fmt"
    "log"
    "net/http"
    "os"    
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
    
    err := os.Getenv("user")

    // host := "/cloudsql/pantheon-lighthouse-poc:us-central1:lighthousedb"

    // dbURI := fmt.Sprintf("%s:%s@unix(/%s)/%s?parseTime=true&multiStatements=true", user, password, host, dbname)

    // _, err := sql.Open("mysql", dbURI)
    fmt.Println("testing build")

    if err == "" {
        err = "test"
    }


    // // db, _ := sql.Open("mysql", "user:password@tcp(host:port)/dbname?multiStatements=true")
    // driver, _ := mysql.WithInstance(db, &mysql.Config{})
    // m, _ := migrate.NewWithDatabaseInstance(
    //     "file:///migrations",
    //     "mysql", 
    //     driver,
    // )
    
    // m.Steps(2)
    w.WriteHeader(http.StatusOK)
    fmt.Fprintln(w, err)
}
