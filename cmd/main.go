package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"time"

	"github.com/gin-gonic/gin"
)

func main() {

	gin.SetMode(gin.DebugMode)
	router := gin.Default()
	router.GET("/", func(c *gin.Context) {
		c.AbortWithStatusJSON(http.StatusOK, gin.H{
			"msg": "Hello, Welcome Gin Server!",
		})
	})
	router.GET("/health", func(c *gin.Context) {
		c.AbortWithStatusJSON(http.StatusOK, gin.H{
			"msg":  http.StatusText(http.StatusOK),
			"code": http.StatusOK,
		})
	})

	addr := os.Getenv("GO_FIRST_HOST")
	if addr == "" {
		addr = ":8080"
	}

	srv := &http.Server{
		Addr:        addr,
		Handler:     router,
		ReadTimeout: 3 * time.Second,
	}

	go func() {
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Printf("listen: %s\n", err)
		}
	}()

	quit := make(chan os.Signal)
	signal.Notify(quit, os.Interrupt)
	<-quit
	log.Println("Shutdown Server ...")

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := srv.Shutdown(ctx); err != nil {
		log.Printf("Server Shutdown: %s\n", err)
	}
	log.Println("Server exiting")
}
