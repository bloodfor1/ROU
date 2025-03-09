using System;


public class DescribeAttribute : Attribute
{
    public string Desc;
    public DescribeAttribute(string desc)
    {
        Desc = desc;
    }
}

