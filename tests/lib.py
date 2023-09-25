def price_to_int(price: str) -> float:
    for i,a in enumerate(price):
        try:
            int(a)
            break
        except:
            pass
    price = price[i:]
    return float(price)
