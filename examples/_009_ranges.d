/// This example shows how to use Joka's range utilities.

import joka;
import joka.ranges;

void main(string[] args) {
    // NumericRange
    auto temp = 0;
    foreach (i; range(0, 4)) {
        assert(i == temp);
        temp += 1;
    }
    temp = 0;
    foreach (i; range(0, -4, -1)) {
        assert(i == temp);
        temp -= 1;
    }
    assert(range(0, 10).reduce((int x, int y) => x + y, 0) == 45);

    // ArrayRange
    int[5] slice = [1, 2, 3, 4, 5];
    assert(slice.range().reduce((int x, int y) => x + y, 0) == 15);
    assert(slice.range()[2] == 3);
    assert(slice.range().length == 5);

    // EnumeratedRange
    temp = 0;
    foreach (item; range(10, 13).enumerate()) {
        assert(item.index == temp);
        temp += 1;
    }
    temp = 5;
    foreach (item; range(10, 13).enumerate(5)) {
        assert(item.index == temp);
        temp += 1;
    }

    // MapRange
    assert(range(0, 4).map((int x) => x * 2).reduce((int x, int y) => x + y, 0) == 12);
    assert(
        range(1, 5)
            .map((int x) => x * 2)
            .filter((int x) => x > 4)
            .reduce((int a, int b) => a + b, 0)
            == 14
    );

    // FilterRange
    assert(range(0, 9).filter((int x) => x == 2 || x == 4).reduce((int x, int y) => x + y, 0) == 6);
    auto f = range(0, 5).filter((int x) => x % 2 == 0);
    assert(!f.empty);
    assert(!f.empty); // Second call must not skip elements.
    assert(f.front == 0);
    assert(range(0, 5).filter((int x) => x > 10).reduce((int x, int y) => x + y, 0) == 0);

    // any/all/countIf
    assert(range(0, 5).any((int x) => x == 3));
    assert(!range(0, 5).any((int x) => x == 9));
    assert(range(1, 5).all((int x) => x > 0));
    assert(!range(0, 5).all((int x) => x > 0));
    assert(range(0, 10).countIf((int x) => x % 2 == 0) == 5);

    // TakeRange
    assert(range(0, 10).take(3).reduce((int a, int b) => a + b, 0) == 3);
    assert(range(0, 10).take(0).empty);

    // drop
    assert(range(0, 5).drop(3).reduce((int a, int b) => a + b, 0) == 7);
    assert(range(0, 3).drop(3).empty);

    // ChainRange
    assert(chain(range(0, 3), range(3, 6)).reduce((int a, int b) => a + b, 0) == 15);

    // min/max
    assert(range(1, 6).min == 1);
    assert(range(1, 6).max == 5);

    // dropWhile
    assert(range(0, 5).dropWhile((int x) => x < 3).reduce((int a, int b) => a + b, 0) == 7);
    assert(range(0, 5).dropWhile((int x) => x < 9).empty);

    // last
    assert(range(0, 5).last == 4);
    assert(range(1, 2).last == 1);

    // sum/product
    assert(range(1, 6).sum == 15);
    assert(range(1, 6).product == 120);

    // StrideRange
    assert(range(0, 10).stride(3).reduce((int a, int b) => a + b, 0) == 18);
    assert(range(0, 10).stride(1).reduce((int a, int b) => a + b, 0) == 45);

    // AccumulateRange
    assert(range(1, 5).accumulate((int a, int b) => a + b, 0).last == 10);
    assert(range(1, 5).reduce((int a, int b) => a + b, 0) == 10);

    // ChunksRange
    auto c = range(0, 6).chunks(2);
    assert(c.front.sum == 1);
    c.popFront();
    assert(c.front.sum == 5);
    c.popFront();
    assert(c.front.sum == 9);
    c.popFront();
    assert(c.empty == true);
}
