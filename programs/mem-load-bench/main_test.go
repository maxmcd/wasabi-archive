package main

import (
	"bytes"
	"compress/gzip"
	"crypto/rand"
	"io/ioutil"
	"log"
	"os"
	"testing"
)

func makeData() []byte {
	data := make([]byte, 8388608)  // 8mb
	rand.Read(data[0 : 1000*1000]) // load the first mb with random data to simulate stack and heap use
	return data
}

func compress(data []byte) []byte {
	var buf bytes.Buffer
	zw := gzip.NewWriter(&buf)
	if _, err := zw.Write(data); err != nil {
		log.Fatal(err)
	}
	if err := zw.Close(); err != nil {
		log.Fatal(err)
	}
	return buf.Bytes()
}

func tmpfile() *os.File {
	tmpfile, err := ioutil.TempFile("./", "example")
	if err != nil {
		panic(err)
	}
	return tmpfile
}

func BenchmarkWrite(b *testing.B) {
	data := makeData()
	for i := 0; i < b.N; i++ {
		tf := tmpfile()
		tf.Write(data)
		os.Remove(tf.Name())
	}
}

func BenchmarkJustContentWrite(b *testing.B) {
	data := makeData()
	contentIndex := 0
	for i := 0; i < b.N; i++ {
		for i, b := range data {
			if b != 0 {
				contentIndex = i
			}
		}
		tf := tmpfile()
		tf.Write(data[0:contentIndex])
		os.Remove(tf.Name())
	}
}

func BenchmarkZipThenWrite(b *testing.B) {
	data := makeData()

	for i := 0; i < b.N; i++ {
		data = compress(data)
		tf := tmpfile()
		tf.Write(data)
		os.Remove(tf.Name())
	}

}

func BenchmarkUnzipAfterLoad(b *testing.B) {
	data := makeData()
	data = compress(data)
	tf := tmpfile()
	tf.Write(data)
	tf.Close()

	for i := 0; i < b.N; i++ {
		f, err := os.Open(tf.Name())
		if err != nil {
			b.Error(err)
		}
		zr, err := gzip.NewReader(f)
		if err != nil {
			b.Error(err)
		}
		if _, err := ioutil.ReadAll(zr); err != nil {
			b.Error(err)
		}
	}

	os.Remove(tf.Name())
}

func BenchmarkLoad(b *testing.B) {
	data := makeData()
	tf := tmpfile()
	tf.Write(data)
	tf.Close()

	for i := 0; i < b.N; i++ {
		_, err := ioutil.ReadFile(tf.Name())
		if err != nil {
			b.Error(err)
		}
	}

	os.Remove(tf.Name())
}
