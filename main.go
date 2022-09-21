package main

import (
	"database/sql"
	"embed"
	"fmt"
	"log"
	"net/http"
	"os"

	_ "github.com/go-sql-driver/mysql"
    "github.com/golang-migrate/migrate/v4"
	"github.com/golang-migrate/migrate/v4/database/mysql"
    _ "github.com/golang-migrate/migrate/v4/source/file"
	"github.com/golang-migrate/migrate/v4/source/iofs"
	_ "github.com/spf13/cobra"
)

var fs embed.FS

// type User struct {
// 	ID        int `gorm:"primaryKey,autoIncrement"`
// 	Firstname string
// 	Lastname  string
// }

// var rootCmd = &cobra.Command{
// 	Use:   "app",
// 	Short: "this is go migrate example",
// }

// var migrateCmd = &cobra.Command{
// 	Use:   "migrate",
// 	Short: "Run database migration",

// 	Run: func(cmd *cobra.Command, args []string) {
//         fmt.Println("testing migration open")
// 		user := os.Getenv("user")
// 		if user == "" {
// 			fmt.Errorf("user is not empty")
// 			return
// 		}
//         fmt.Printf("%v", user)

// 		password := os.Getenv("password")
// 		if password == "" {
// 			fmt.Errorf("password is not empty")
// 			return

// 		}

// 		dbname := os.Getenv("dbname")
// 		if dbname == "" {
// 			fmt.Errorf("dbname is not empty")
// 			return
// 		}

// 		host := "/cloudsql/pantheon-lighthouse-poc:us-central1:lighthousedb"

// 		dbURI := fmt.Sprintf("%s:%s@unix(/%s)/%s?parseTime=true", user, password, host, dbname)

// 		d, err := iofs.New(fs, "migrations")
// 		if err != nil {
// 			log.Fatal(err)
// 		}
// 		m, err := migrate.NewWithSourceInstance(
// 			"iofs", d, dbURI)
// 		if err != nil {
// 			panic(fmt.Sprintf("unable to connect database %v", err))
// 		}
// 		m.Up()
//         fmt.Println("testing migration finish")
// 	},
// }

// func init() {
//     fmt.Printf("start init func\n")
// 	rootCmd.AddCommand(migrateCmd)
//     fmt.Printf("end init function\n")
// }

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
    d, err := iofs.New(fs, "db/migration/")
    if err != nil {
        fmt.Printf("start\n")
        log.Fatal(err)
        fmt.Printf("end\n")
    }
    log.Printf("%v", d)

	m, err := migrate.NewWithDatabaseInstance(
	    "file://./db/migration",
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
