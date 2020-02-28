var object = {
    aProperty: {
        aSetting1: 1,
        aSetting2: 2,
        aSetting3: 3,
        aSetting4: 4,
        aSetting5: 5
    },
    bProperty: {
        bSetting1: {
            bPropertySubSetting: true
        },
        bSetting2: "bString"
    },
    cProperty: {
        cSetting: "cString"
    }
}

    function iterate(obj, p) {
        for (var property in obj) {
            if (obj.hasOwnProperty(property)) {
                if (typeof obj[property] == "object") {
                    iterate(obj[property], p);
                } else {
                    let regex = new RegExp("bString");
                    console.log(property + "   " + obj[property].toString()
                        .replace(regex, 'replaced'));
                }
            }
        }
    }

iterate(object, "bString");
