'''
����: ������������ȡ��if��֧
'''

# ATM 100������
def login():
    pass

def register():
    pass


# �����ֵ�����
func_dic = {
    '1': login,
    '2': register,
}

choice = input('�����빦������: ').strip()

if choice in func_dic:
    # ������ʹ��dict.get��ʽȡֵ
    func_dic.get(choice)()

#
# if choice == 'login':
#     login()
# elif choice == 'register':
#     register()
# else:
#     print('�������!')