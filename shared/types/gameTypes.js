/**
 * ONLINE TAVLA - Game Types
 * Ortak tip tanımları. Agent 5 yönetir, diğer agent'lar OKUR.
 */

/**
 * @typedef {Object} GameState
 * @property {string} id - Oyun ID
 * @property {Player} white - Beyaz oyuncu
 * @property {Player} black - Siyah oyuncu
 * @property {'white'|'black'} currentTurn - Sırası olan oyuncu
 * @property {number[]} dice - Zar sonuçları [zar1, zar2]
 * @property {number[]} remainingMoves - Kalan hamle değerleri
 * @property {'waiting'|'rolling'|'moving'|'finished'} phase
 * @property {Point[]} points - 24 üçgen
 * @property {Bar} bar - Orta bar
 * @property {BearOff} bearoff - Toplama bölgesi
 * @property {Move[]} moveHistory - Hamle geçmişi
 */

/**
 * @typedef {Object} Player
 * @property {string} id - Oyuncu ID
 * @property {string} name - Oyuncu adı
 * @property {'white'|'black'} color - Pul rengi
 * @property {number} score - Skor
 * @property {boolean} isOnline - Online durumu
 */

/**
 * @typedef {Object} Point
 * @property {number} index - Üçgen numarası (1-24)
 * @property {'white'|'black'|null} owner - Üzerindeki pulların rengi
 * @property {number} count - Pul sayısı
 */

/**
 * @typedef {Object} Bar
 * @property {number} white - Beyaz pul sayısı
 * @property {number} black - Siyah pul sayısı
 */

/**
 * @typedef {Object} BearOff
 * @property {number} white - Beyaz toplanan pul sayısı
 * @property {number} black - Siyah toplanan pul sayısı
 */

/**
 * @typedef {Object} Move
 * @property {'white'|'black'} player
 * @property {number} from - Kaynak point (0=bar, 25=bearoff)
 * @property {number} to - Hedef point
 * @property {number} diceValue - Kullanılan zar değeri
 * @property {boolean} isHit - Pul yendi mi
 */

// Başlangıç dizilimi
const INITIAL_SETUP = {
    white: { 24: 2, 13: 5, 8: 3, 6: 5 },
    black: { 1: 2, 12: 5, 17: 3, 19: 5 }
};

// Ev bölgeleri
const HOME_BOARD = {
    white: [1, 2, 3, 4, 5, 6],
    black: [19, 20, 21, 22, 23, 24]
};

// Hareket yönleri
const DIRECTION = {
    white: -1,  // 24'ten 1'e doğru
    black: 1    // 1'den 24'e doğru
};

export { INITIAL_SETUP, HOME_BOARD, DIRECTION };