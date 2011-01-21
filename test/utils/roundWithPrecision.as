package utils
{
    public function roundWithPrecision(value:Number, precision:Number):Number
    {
        if (precision > 1)
            throw new Error("Precision parameter should be less or equal to 1!");

        if (precision < 0)
            throw new Error("Precision parameter should be positive!");

        return Math.round(value / precision) * precision;
    }
}
