from app.models.captcha import CaptchaPicture

CAPTCHA_DATA = [
    {
        'id': "b7B3",
        'img': "https://ltdfoto.ru/images/2024/07/06/100595a04231ec17f.jpg",
    },
    {
        'id': "dF5p",
        'img': "https://ltdfoto.ru/images/2024/07/06/270e653bcb159cb96.jpg",
    },
    {
        'id': "a9a2",
        'img': "https://ltdfoto.ru/images/2024/07/06/372e78a066628800c.jpg",
    },
    {
        'id': "kL4c",
        'img': "https://ltdfoto.ru/images/2024/07/06/42861289dce0eeed0.jpg",
    },
    {
        'id': "r6wS",
        'img': "https://ltdfoto.ru/images/2024/07/06/5e2485a248af64289.jpg",
    },
    {
        'id': "y1T8",
        'img': "https://ltdfoto.ru/images/2024/07/06/600bba36224ea638a.jpg",
    },
    {
        'id': "hG0j",
        'img': "https://ltdfoto.ru/images/2024/07/06/7095d29ed9262c448.jpg",
    },
    {
        'id': "m5m9",
        'img': "https://ltdfoto.ru/images/2024/07/06/81f497f063cd0a99b.jpg",
    },
    {
        'id': "b2vE",
        'img': "https://ltdfoto.ru/images/2024/07/06/908de7b0868297b16.jpg",
    }
]

CAPTCHA = [CaptchaPicture(id=item['id'], img=item['img']) for item in CAPTCHA_DATA]

CAPTCHA_TRUE_CODE = 'b7B3dF5pa9a2kL4cr6wSy1T8hG0jm5m9b2vE'

