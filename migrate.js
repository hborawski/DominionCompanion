const fs = require('fs')
const readline = require('readline')

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

const autoFilters = [
    card => card.types.includes('Event'),
    card => card.types.includes('Boon'),
    card => card.types.includes('Hex'),
    card => card.types.includes('State'),
    card => card.types.includes('Heirloom'),
    card => card.types.includes('Ruins'),
    card => card.types.includes('Prize'),
    card => card.types.includes('Shelter'),
    card => card.types.includes('Castle'),
    card => card.types.includes('Landmark')
]
const data = fs.readFileSync('cards.json')
let json = JSON.parse(data)
let index = 0

json.forEach((c, i) => {
    if (autoFilters.find(f => f(c) == true)) {
        json[i].supply = false
    }
})

fs.writeFileSync('cards.json', JSON.stringify(json, null, 2))
process.exit(0)

// let updatePrompt = () => {
//     rl.setPrompt(`${json[index].name}: `)
// }

// rl.on('line', line => {
//     if (line == 'q') {
//         rl.close()
//         fs.writeFileSync('cards.json', JSON.stringify(json, null, 2))
//         process.exit(0)
//     }
//     if (index < json.length) {
//         if (line == '1') {
//             json[index].supply = true
//         } else if (line == '2') {
//             json[index].supply = false
//         }
//         index += 1
//         console.log(json[index].text)
//         updatePrompt()
//         rl.prompt()
//     }
// })
// console.log(json[index].text)
// updatePrompt()
// rl.prompt()