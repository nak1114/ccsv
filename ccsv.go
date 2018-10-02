package main

import (
	"encoding/csv"
	"flag"
	"fmt"
	"log"
	"os"

	"github.com/fatih/color"
)

//Version is app versioin
var Version = "0.0.1"

var (
	isVersion = flag.Bool("version", false, "Display version")
)

func main() {
	flag.Parse()
	if *isVersion {
		fmt.Println("ccsv Version " + Version)
		os.Exit(0)
	}

	colors := []color.Attribute{color.FgRed,
		color.FgGreen,
		color.FgYellow,
		color.FgBlue,
		color.FgMagenta,
		color.FgCyan,
	}

	fr, err := os.Open(flag.Arg(0))
	if err != nil {
		log.Fatal("Error:", err)
	}
	defer fr.Close()

	r := csv.NewReader(fr)
	rows, err := r.ReadAll()
	if err != nil {
		log.Fatal("Error:", err)
	}

	csize := len(colors)
	for _, cells := range rows {
		size := len(cells) - 1
		for i, value := range cells {
			cc := color.New(colors[i%csize])
			cc.Print(value)
			if i < size {
				cc.Print(",")
			}
		}
		fmt.Println("")
	}
}
