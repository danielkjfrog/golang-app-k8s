package main

import (
	"fmt"
	"github.com/go-redis/redis"
	"github.com/julienschmidt/httprouter"
	"log"
	"net/http"
	"os"
)

func main() {

	r := httprouter.New()

	serverPort := GetEnv("SERVER_PORT", "9090")

	/*
		Endpoints
	*/
	r.GET("/", handler)

	r.GET("/api/v1/system/ping", pingHandler)

	r.GET("/api/v1/system/readiness", readinessHandler)

	/*
		App Startup
	*/
	log.Printf(fmt.Sprintf("Web Server running on http://localhost:%s", serverPort))

	http.ListenAndServe(":"+serverPort, r)

}

func GetEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}

func handler(w http.ResponseWriter, r *http.Request, params httprouter.Params) {
	w.WriteHeader(http.StatusOK)
	query := r.URL.Query()
	name := query.Get("name")
	if name == "" {
		name = "Guest"
	}
	log.Printf("Received request for %s\n", name)
	w.Write([]byte(fmt.Sprintf("Hello, %s\n", name)))
}

func pingHandler(w http.ResponseWriter, r *http.Request, params httprouter.Params) {
	w.WriteHeader(http.StatusOK)
}

func readinessHandler(w http.ResponseWriter, r *http.Request, params httprouter.Params) {
	client := rClient()
	_, err := client.Ping().Result()
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
	}
	log.Printf("App ready for use. Connected to Redis!")
	w.WriteHeader(http.StatusOK)
}

func rClient() *redis.Client {
	redisHost := GetEnv("REDIS_HOST", "localhost")
	redisPort := GetEnv("REDIS_PORT", "6379")
	redisAddr := redisHost + ":" + redisPort
	client := redis.NewClient(&redis.Options{
		Addr: redisAddr,
	})
	return client
}
