# coding: utf-8

import os

from leader import Leader


def work():
    product_owner_comment = os.environ.get('PRODUCT_OWNER_COMMENT')

    print(f'Product owner: {product_owner_comment}')

    leader = Leader(product_owner_comment=product_owner_comment)

    leader.work()


if __name__ == "__main__":
    work()
