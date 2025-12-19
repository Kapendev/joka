package main

import (
	"fmt"
	"os"
	"strconv"
)

func main() {
	n := 0
	if len(os.Args) > 1 {
		var err error
		n, err = strconv.Atoi(os.Args[1])
		if err != nil {
			fmt.Println("Invalid number")
			return
		}
	}
	if n == 0 {
		fmt.Println("Usage: array_append_remove <count>")
		return
	}

	var array []int
	for i := 0; i < n; i++ {
		array = append(array, i)
	}
	for len(array) != 0 {
		array = array[:len(array)-1]
	}
}
