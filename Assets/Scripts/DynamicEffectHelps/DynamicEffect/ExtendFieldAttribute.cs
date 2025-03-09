using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

[AttributeUsage(AttributeTargets.Class, AllowMultiple = true)]
public class ExtendFieldAttribute : Attribute
{
    public string FieldName;
    public Type FieldType;
    public string Desc;

    public ExtendFieldAttribute(string fieldName, Type fieldType)
    {
        setType(fieldType);
        setFieldName(fieldName);
    }

    public ExtendFieldAttribute(string fieldName, Type fieldType, string desc)
    {
        setFieldName(fieldName);
        setType(fieldType);
        setDesc(desc);
    }

    private void setFieldName(string fieldName)
    {
        if (string.IsNullOrEmpty(fieldName))
        {
            FieldName = "默认名字";
            return;
        }
        FieldName = fieldName;
    }
    private void setType(Type fieldType)
    {
        if (fieldType==null)
        {
            FieldType =typeof(object);
            return;
        }
        FieldType =fieldType;
    }
    private void setDesc(string desc)
    {
        if (string.IsNullOrEmpty(desc))
        {
            Desc = "暂无描述";
            return;
        }
        Desc = desc;
    }
}

