/**
 * Zar Motoru - Agent 4 + Agent 5
 * Zar atma, çift kontrolü
 */

// TODO: Dalga 3 - A4-3 fazında implement edilecek
export function rollDice() {
    const d1 = Math.floor(Math.random() * 6) + 1;
    const d2 = Math.floor(Math.random() * 6) + 1;
    const isDouble = d1 === d2;
    return { dice: [d1, d2], isDouble, moves: isDouble ? [d1, d1, d1, d1] : [d1, d2] };
}

export default { rollDice };