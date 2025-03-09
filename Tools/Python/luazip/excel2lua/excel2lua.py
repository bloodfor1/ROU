import sys
import os
import xlrd
import re

curpath = os.path.dirname(os.path.abspath(sys.argv[0]))

lua_file_head_format_desc = '''--[[

        %s
        exported by excel2lua.py
        from file:%s

--]]\n\n'''

def excel2lua():
    list = os.listdir(curpath)
    for i in range(0,len(list)):
        nowpath = os.path.join(curpath,list[i])
        if os.path.isfile(nowpath) and os.path.splitext(nowpath)[1] == '.xlsx':
            portion = os.path.splitext(nowpath)
            luapath = portion[0] + ".lua"
            # load excel data
            excel_data_src = xlrd.open_workbook(nowpath, encoding_override = 'utf-8')
            print('[excel] Worksheet name(s):', excel_data_src.sheet_names())
            excel_sheet = excel_data_src.sheet_by_index(0)
            print('[excel] parse sheet: %s (%d row, %d col)' % (excel_sheet.name, excel_sheet.nrows, excel_sheet.ncols))

            # excel data dict
            excel_data_dict = {}

            # col name list
            col_name_list = []

            # ctype: 0 empty, 1 string, 2 number, 3 date, 4 boolean, 5 error

            for col in range(0, excel_sheet.ncols):
                cell = excel_sheet.cell(0, col)
                col_name_list.append(str(col + 1))
                assert cell.ctype == 1, "found a invalid col name in col [%d] !~" % (col)

            for row in range(2, excel_sheet.nrows):
                cell_id = excel_sheet.cell(row, 0)

                assert cell_id.ctype == 2, "found a invalid id in row [%d] !~" % (row)

                if cell_id.value in excel_data_dict:
                    print('[warning] duplicated data id: "%d", all previous value will be ignored!~' % (cell_id.value))

                # row data list
                row_data_list = []

                for col in range(0, excel_sheet.ncols):
                    cell = excel_sheet.cell(row, col)
                    k = col_name_list[col]

                    # ignored the string that start with '_'
                    if str(k).startswith('_'):
                        continue
                    v = cell.value

                    row_data_list.append([k, v])

                excel_data_dict[cell_id.value] = row_data_list

            searchObj = re.search(r'([^\\/:*?"<>|\r\n]+)\.\w+$', nowpath, re.M|re.I)
            lua_table_name = searchObj.group(1)
        	
            src_excel_file_name = os.path.basename(nowpath)
            tgt_lua_file_name = os.path.basename(luapath)

            lua_file_head_desc = lua_file_head_format_desc % (tgt_lua_file_name, src_excel_file_name)

            lua_export_file = open(luapath, 'w')
            lua_export_file.write(lua_file_head_desc)
            lua_export_file.write('%s = {\n' % lua_table_name)

            for k, v in excel_data_dict.items():
                lua_export_file.write('  [%d] = {' % k)
                for row_data in v:
                    lua_export_file.write(' [{0}] = {1},'.format(row_data[0], row_data[1]))
                lua_export_file.write('  },\n')

            lua_export_file.write('}\n')

            lua_export_file.close()

            print('[excel] %d row data exported!~' % (excel_sheet.nrows))

if __name__ == '__main__':
    excel2lua()

    exit(0)