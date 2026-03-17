/**
 * ONLINE TAVLA - Object Registry
 * Tüm 3D nesnelerin merkezi kayıt defteri.
 * Agent 5 yönetir, diğer agent'lar OKUR.
 */

const ObjectRegistry = {
    board: {
        path: 'objects/board/',
        type: 'static',
        description: 'Tavla tahtası ana gövdesi',
        hasInteract: true
    },
    point: {
        path: 'objects/point/',
        type: 'interactive',
        count: 24,
        description: 'Üçgenler (siyah/krem dönüşümlü)',
        hasInteract: true
    },
    checker: {
        path: 'objects/checker/',
        type: 'interactive',
        count: 30,
        description: 'Pullar (15 siyah + 15 beyaz)',
        hasInteract: true
    },
    dice: {
        path: 'objects/dice/',
        type: 'interactive',
        count: 2,
        description: 'Zarlar (beyaz, siyah noktalı)',
        hasInteract: true
    },
    bar: {
        path: 'objects/bar/',
        type: 'zone',
        description: 'Orta bar (yenen pulların bekleme yeri)',
        hasInteract: true
    },
    bearoff: {
        path: 'objects/bearoff/',
        type: 'zone',
        description: 'Toplama bölgesi (pulların çıkış yeri)',
        hasInteract: true
    },
    border: {
        path: 'objects/border/',
        type: 'decorative',
        description: 'Tahta kenar çerçevesi',
        hasInteract: false
    }
};

export default ObjectRegistry;