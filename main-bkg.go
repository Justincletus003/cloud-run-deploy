package main

import (
	"database/sql"
	_ "embed"
	"fmt"
	"log"
	"net/http"
	"os"
    "path/filepath"
    "runtime"

	_ "github.com/go-sql-driver/mysql"
    "github.com/golang-migrate/migrate/v4"
	"github.com/golang-migrate/migrate/v4/database/mysql"
    _ "github.com/golang-migrate/migrate/v4/source/file"
	_ "github.com/golang-migrate/migrate/v4/source/iofs"
	_ "github.com/spf13/cobra"
)


var (
    _, b, _, _ = runtime.Caller(0)
    basepath   = filepath.Dir(b)
)

func main() {
	fmt.Print("Starting server ")
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

func handler(w http.ResponseWriter, r *http.Request) {
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

	dbURI := fmt.Sprintf("%s:%s@unix(/%s)/%s?parseTime=true&multiStatements=true", user, password, host, dbname)

	db, err := sql.Open("mysql", dbURI)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
		return
	}

	dbDriver, err := mysql.WithInstance(db, &mysql.Config{})
	if err != nil {
	    w.Write([]byte(err.Error()))
	    return
	}
    fmt.Println(basepath)

	m, err := migrate.NewWithDatabaseInstance(
	    "file:///migrations",
	    "mysql",
	    dbDriver,
	)
	if err != nil {
        w.WriteHeader(http.StatusInternalServerError)
        log.Fatal(err)
        fmt.Printf("\n")
	    w.Write([]byte(err.Error()))
	    return
	}
    if err := m.Up(); err != nil {
        log.Fatal(err)
    }
	// m.Steps(2)
    fmt.Print("migration tested\n")
	// fmt.Println(dbDriver)
	w.WriteHeader(http.StatusOK)
	fmt.Fprintln(w, "database successfully connected")
}
