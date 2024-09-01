package backend;

import haxe.ds.StringMap;

typedef MultiStringArray = {
    fc:Array<String>,
    hit:Array<String>,
    judgeCount:Array<String>,
}

final class RatingStuff {
    // basically to shorten playstate a little bit
    public static final ratingsMap:StringMap<MultiStringArray> = [
        'Tails Gets Trolled V4' => {
            fc: [
                'No Play', 'KFC', 'AFC', 'CFC', 'SDC', 'FC', 'SDCB', 'Clear', 'TDCB', 'QDCB'
            ],
            hit: ['Killer!!!', 'Awesome!!', 'Cool!', 'Gay.', 'Retarded.', 'Fail..'],
            judgeCount: ['Killers', 'Awesomes', 'Cools', 'Gays', 'Retardeds', 'Fails']
        },
        'Doki Doki+' => {
            fc: null,
            hit: ['Very Doki!!!', 'Doki!!', 'Good!', 'OK.', 'No.', 'Miss..'],
            judgeCount: ['Very Doki', 'Doki', 'Good', 'OK', 'No', 'Misses']
        },
        'VS Impostor' => {
            fc: null,
            hit: ['VERY SUSSY!!!', 'Sussy!!', 'Sus!', 'Sad.', 'ASS!', 'Miss..'],
            judgeCount: ['Very Sussy', 'Sussy', 'Sus', 'Sad', 'Ass', 'Miss']
        },
        'FIRE IN THE HOLE' => {
            fc: null,
            hit: ['Easy :D', 'Normal!!', 'Hard!', 'Harder.', 'INSANE!', 'FIRE IN THE HOLE!'],
            judgeCount: ['Easys', 'Normals', 'Hards', 'Harders', 'Insanes', 'Extreme Demon Fails']
        }
    ];
}