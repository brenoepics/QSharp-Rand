namespace Generator {
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;

    @EntryPoint()
    operation Main() : Int[] {
        let limit = 2147483;
        let maxNumbers = 50;
        Message($"Generating random numbers between 0 and {limit}");

        let randomNumbers = GenerateRandomNumbers(maxNumbers, limit);
        let sortedNumbers = BubbleSort(randomNumbers);
        Message($"Sorted random numbers: {sortedNumbers}");
        let primeNumbers = FilterPrimeNumbers(sortedNumbers);
        Message($"Primes: {primeNumbers}");

        return randomNumbers;
    }

    /// # Summary
    /// Generates a list of `count` random numbers, each between 0 and `max`.
    operation GenerateRandomNumbers(count : Int, max : Int) : Int[] {
        mutable numbers = [];
        for idx in 0..count - 1 {
            let num = GenerateRandomNumberInRange(max);
            if not (IsInArray(numbers, num)) {
                set numbers += [num];
            }
        }
        return numbers;
    }

    /// # Summary
    /// Generates a random number between 0 and `max`.
    operation GenerateRandomNumberInRange(max : Int) : Int {
        mutable bits = [];
        let nBits = BitSizeI(max);
        for idxBit in 1..nBits {
            set bits += [GenerateRandomBit()];
        }
        let sample = ResultArrayAsInt(bits);
        return sample > max ? GenerateRandomNumberInRange(max) | sample;
    }

    /// # Summary
    /// Generates a random bit.
    operation GenerateRandomBit() : Result {
        use q = Qubit();
        H(q);

        let result = M(q);
        Reset(q);
        return result;
    }

    /// # Summary
    /// Implements a bubble sort algorithm to sort an array of integers.
    operation BubbleSort(arr : Int[]) : Int[] {
        mutable sortedArr = arr;
        let n = Length(arr);

        for i in 0..n-1 {
            for j in 0..n-i-2 {
                if sortedArr[j] > sortedArr[j+1] {
                    let temp = sortedArr[j];
                    set sortedArr w/= j <- sortedArr[j+1];
                    set sortedArr w/= j+1 <- temp;
                }
            }
        }

        return sortedArr;
    }

    /// # Summary
    /// Checks if a given number is prime.
    function IsPrime(n : Int) : Bool {
        if n <= 1 {
            return false;
        }
        for i in 2..(n / 2) {
            if (n % i) == 0 {
                return false;
            }
        }
        return true;
    }

    /// # Summary
    /// Filters the prime numbers from an array of integers.
    function FilterPrimeNumbers(arr : Int[]) : Int[] {
        mutable primes = [];
        for num in arr {
            if IsPrime(num) {
                set primes += [num];
            }
        }
        return primes;
    }

        /// # Summary
    /// Checks if a given number is in an array.
    function IsInArray(arr : Int[], item : Int) : Bool {
        for elem in arr {
            if elem == item {
                return true;
            }
        }
        return false;
    }
}
