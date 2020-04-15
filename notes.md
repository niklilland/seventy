
Convert NT verse to JSON with each word as an object with two keys: english


const reference = {
  book: "Matthew",
  chapter: 3,
  verses: [
    {
      index: 0,
      text: "in the beginning"
    }
  ],
  language: { // 
    0: {
      "in": "greek1",
      "the": "greek2",
      "beginning": "greek3",
    }
  }
}