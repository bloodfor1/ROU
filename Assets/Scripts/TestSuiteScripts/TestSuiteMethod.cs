using System;

[AttributeUsage(AttributeTargets.Method)]
public class TestSuiteMethod : Attribute
{
    public string _name;
    public string Name => _name;

    public TestSuiteMethod(string name)
    {
        _name = name;
    }
}