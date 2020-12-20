import { setupMaster } from 'cluster';
import { readFileSync } from 'fs';
import { exit } from 'process';

const file = readFileSync('./input.txt', 'utf-8');
const images = file.split('\n\n')
                   .map((image) => image.split(':\n'))
                   .map((image) => { return {id: parseInt(image[0].split(' ')[1]), 
                                             img: image[1].split('\n').map(line => line.split(""))}});
const pattern = ["                  # ", 
                 "#    ##    ##    ###", 
                 " #  #  #  #  #  #   "].map(row => row.split(""));

const n = images.length;

const rotate = (matrix: any[][]) => {
    return matrix.map((row, i) =>
        row.map((val, j) => matrix[matrix.length - 1 - j][i])
    );
};

const rotateImage = (image: any[][], num=1) => {
    while (num < 0) num += 4;
    num %= 4;
    for (let i = 0; i < num; ++i) image = rotate(image);
    return image;
}

const flip = (img: any[][]) => {
    return img.map(row => row.slice().reverse());
}

const getPossibleEdges = (img: string[][]) => {
    let n = img.length;
    let ret = [];
    for (let i = 0; i < 2; ++i) {
        let rotated:string[][] = rotateImage(img, i);
        ret.push({rot: i, flip: false, edge: rotated[0]});
        ret.push({rot: i, flip: true, edge: rotated[0].slice().reverse()});
        ret.push({rot: i+2, flip: true, edge: rotated[n-1]});
    }
    for (let i = 2; i < 4; ++i) {
        ret.push({rot: i, flip: false, edge: rotateImage(img, i)[0]});
    }
    return ret;
}

const match = (edge:string, v:string[][], onFound: (edgeObj, img:string[][]) => string[][]) => {
    const possible = getPossibleEdges(v);
    for (const e of possible) {
        if (e.edge.join("") == edge) {
            return onFound(e, rotateImage(v, e.rot));
        }
    }
    return false;
}

const top = (u:string[][], v:string[][]) => {
    return match(u[0].join(""), v, (e, img) => {
        if (!e.flip) img = flip(img);
        return rotateImage(img, 2);
    });
}

const bottom = (u:string[][], v:string[][]) => {
    return match(u[u.length-1].join(""), v, (e, img) => {
        if (e.flip) return flip(img);
        return img;
    });
}

const left = (u:string[][], v:string[][]) => {
    return match(rotateImage(u)[0].join(""), v, (e, img) => {
        if (!e.flip) img = flip(img);
        return rotateImage(img, 1);
    });
}

const right = (u:string[][], v:string[][]) => {
    return match(rotateImage(u, 3)[0].join(""), v, (e, img) => {
        if (!e.flip) img = flip(img);
        return rotateImage(img, 3);
    });
}

const findOne = (polje: string[][], i: number, j: number, goodOnes: boolean[][]) => {
    for (let k = 0; k < pattern.length; ++k) {
        for (let l = 0; l < pattern[0].length; ++l) {
            if (pattern[k][l] == ' ') continue;
            if (pattern[k][l] != polje[i+k][j+l]) return;
        }
    }
    for (let k = 0; k < pattern.length; ++k) {
        for (let l = 0; l < pattern[0].length; ++l) {
            if (pattern[k][l] == ' ') continue;
            if ('#' == polje[i+k][j+l]) goodOnes[i+k][j+l] = false;
        }
    }
}

const findPattern = (polje: string[][], goodOnes: boolean[][]) => {
    for (let i = 0; i < polje.length-pattern.length; ++i) {
        for (let j = 0; j < polje[0].length-pattern[0].length; ++j) {
            findOne(polje, i, j, goodOnes)
        }
    }
}

let cntMap = new Array(5000);
for (let e of images) {
    cntMap[e.id] = new Set();
}

const part1 = () => {
    let ret = 1;
    for (let i = 0; i < n-1; ++i) {
        let iEdges = getPossibleEdges(images[i].img);
        for (let j = i+1; j < n; ++j) {
            let jEdges = getPossibleEdges(images[j].img);
            for (const iEdge of iEdges) {
                for (const jEdge of jEdges) {
                    if (iEdge.edge.join("") == jEdge.edge.join("")) {
                        cntMap[images[j].id].add(images[i].id);
                        cntMap[images[i].id].add(images[j].id);
                    }
                }
            }
        }
    }
    for (const e of images) {
        if (cntMap[e.id].size == 2) ret *= e.id;
    }
    return ret;
}

const part2 = () => {
    let idk = {};
    for (const e of images) {
        idk[e.id] = e.img;
    }
    const N = 250
    let polje = new Array<Array<string>>(N);
    for (let i = 0; i < N; ++i) {
        polje[i] = new Array<string>(N);
    }
    
    // <BFS>
    let bio = new Array(4000);
    bio.fill(false);
    let queue = new Array();
    queue.push([images[0].id, N/2, N/2]);
    bio[images[0].id] = true;
    while (queue.length > 0) {
        const [uid, x, y] = queue.shift();
        const u = idk[uid];
        for (let i = 1; i < u.length-1; ++i) {
            for (let j = 1; j < u[0].length-1; ++j) {
                polje[y+i][x+j] = u[i][j];
            }
        }
        cntMap[uid].forEach(vid => {
            if (bio[vid]) return;
            const v = idk[vid];
            let res;
            if (res = top(u, v)) {
                idk[vid] = res;
                bio[vid] = true;
                queue.push([vid, x, y-10]);
            } else if (res = left(u, v)) {
                idk[vid] = res;
                bio[vid] = true;
                queue.push([vid, x-10, y]);
            } else if (res = bottom(u, v)) {
                idk[vid] = res;
                bio[vid] = true;
                queue.push([vid, x, y+10]);
            } else if (res = right(u, v)) {
                idk[vid] = res;
                bio[vid] = true;
                queue.push([vid, x+10, y]);
            } else {
                console.log("you fucked up");
            }
        });
    }
    // </BFS>
    polje = polje.map(row => row.join("")).filter(row => row.length > 0).map(row => row.split(""));
    
    let goodOnes = new Array<Array<boolean>>(polje.length);
    for (let i = 0; i < goodOnes.length; ++i) {
        goodOnes[i] = new Array<boolean>(polje[0].length);
        for (let j = 0; j < goodOnes[0].length; ++j) {
            goodOnes[i][j] = polje[i][j] == '#';
        }
    }
    
    for (let r = 0; r < 4; ++r) {
        goodOnes = rotateImage(goodOnes, r>0?1:0);
        findPattern(rotateImage(polje, r), goodOnes);
    }
    for (let r = 0; r < 2; ++r) {
        goodOnes = flip(rotateImage(goodOnes, r));
        findPattern(flip(rotateImage(polje, r)), goodOnes);
    }
    
    let ret = 0;
    for (let i = 0; i < goodOnes.length; ++i) {
        for (let j = 0; j < goodOnes[0].length; ++j) {
            ret += goodOnes[i][j]?1:0;
        }
    }
    return ret;
}

console.log("part 1:", part1());
console.log("part 2:", part2());