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
    name := os.Getenv("NAME")
    if name == "" {
        name = "World"
    }
    w.WriteHeader(http.StatusOK)
    fmt.Fprintf(w, "hello %s\n", name)
}
