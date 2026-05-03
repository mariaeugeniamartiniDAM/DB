/**
 * Task BD07 - Maria Eugenia Martini
 */

// 1. Create a database called zoo

use zoo


// 2. Insert a collection called animals.

db.createCollection("animals")


// 3. Confirm that the database and the collection have been successfully created.

db.getSiblingDB("zoo").getCollectionNames()


// 4. Insert the documents contained in the animals.json file.


// 5. Find animals in Rainforest attended by Emily Brown.

db.animals.find({
  habitat: "Rainforest",
  "caretakers.nameCaretaker": "Emily Brown"
})


// 6. Only name, species, and habitat sorted by species (ascending).

db.animals.find({}, { name: 1, species: 1, habitat: 1, _id: 0 }).sort({ species: 1 })


// 7. Tigers, display name and age, sorted by age (descending).

db.animals.find({ species: "Tiger" }, { name: 1, age: 1, _id: 0 }).sort({ age: -1 })


// 8. Insert animal: Leo.

db.animals.insertOne({
  name: "Leo",
  age: 7,
  gender: "Male",
  species: "Lion",
  habitat: "Savanna",
  birthplace: "Masai Mara, Kenya",
  parents: [
    { name: "Unknown", gender: "Male" },
    { name: "Unknown", gender: "Female" }
  ],
  caretakers: [{ idCaretaker: 501, nameCaretaker: "Jake Adams" }]
})

// 9. Update age of Leo to 8 using $set.

db.animals.updateOne({ name: "Leo" }, { $set: { age: 8 } })


// 10. Rename habitat field to environment for all animals.

db.animals.updateMany({}, { $rename: { "habitat": "environment" } })


// 11. Aggregation: animals aged less than 10 sorted by name.

db.animals.aggregate([
  { $match: { age: { $lt: 10 } } },
  { $sort: { name: 1 } }
])

// 12. Aggregation: group by species and count animals.

db.animals.aggregate([
  { $group: { _id: "$species", total: { $sum: 1 } } }
])


// 13. Create new collection Caretakers (unique caretakers and their animals).

db.animals.aggregate([
  { $unwind: "$caretakers" },
  { $group: {
      _id: "$caretakers.nameCaretaker",
      animalsAttended: { $addToSet: "$name" }
  }},
  { $out: "Caretakers" }
])

// 14. Top 3 oldest animals.

db.animals.find().sort({ age: -1 }).limit(3)


// 15. Animals between 6th and 12th entries (insertion order).

db.animals.find().skip(5).limit(7)


// 16. Aggregation: Create collection Habitats.

db.animals.aggregate([
  { $unwind: "$caretakers" },
  { $group: {
      _id: "$environment",
      totalAnimals: { $sum: 1 },
      species: { $addToSet: "$species" },
      caretakers: { $addToSet: "$caretakers.nameCaretaker" }
  }},
  { $project: {
      _id: 0,
      environment: "$_id",
      totalAnimals: 1,
      species: { $sortArray: { input: "$species", sortBy: 1 } },
      caretakers: 1
  }},
  { $out: "Habitats" }
])