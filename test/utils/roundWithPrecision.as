package utils
{
    public function roundWithPrecision(value:Number, precision:Number):Number
    {
        if (precision > 1)
            throw new Error("Precision parameter should be less or equal to 1!");

        if (precision < 0)
            throw new Error("Precision parameter should be positive!");

        var inversePrecision:int = Math.round(1 / precision); // trick to cheat flash rounding error
        return Math.round(value * inversePrecision) / inversePrecision;
    }
}
