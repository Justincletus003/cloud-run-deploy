package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func main() {
	fmt.Print("Starting server ")
	http.HandleFunc("/", Handler)
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	log.Printf("listening on port %s", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}

}

func Handler(w http.ResponseWriter, r *http.Request) {
    fmt.Print("migration tested\n")
	w.WriteHeader(http.StatusOK)
	fmt.Fprintln(w, "database successfully connected")
}
