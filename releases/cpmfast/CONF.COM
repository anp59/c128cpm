1(!� ~���This program is used to set system parameters.     21 Jan 86

The following Commands are currently supported:
40COL	BAUD	BACK	BORD	CHAR
CURSOR	DATE	DRV	DUMP	FEEL
HELP	MAP	PARITY	POKE	PRT1
PRT2	REPEAT	VOL


For more information on the command, type:

A>conf help


      NOTE:	the file CONF.HLP must be on the currently
		logged disk drive.

        Von Ertwine
 �  <�o6!� "�*�~��  #�e(����40CȮBAUĝBAC˙BORġCHAҿCURSO�D	DAT�DRֈDUM�<FEE��HEL�:MA�DPARIT��POK��
PRT��
PRT�7REPEA��VO�  ����failed to use:   *����Î͙8*��missing or bad REPEAT parameter     ��*��m>6#$(>%� ��>!��>"��>����>�#$( %� ��>>��>2��+���(<7��wÑ����Repeat code not found
 Ñ###������� �( ��CONF.HLP file not found
 �,�� !("�T]� � � 	*� @��A8 �'��
Enter Topic you want info on or RETURN to exit:   
s� !t~�ʑ_ #6!u��0�.0���

Missing or bad topic
 �*����1"��.ґ��HELP message missing 
 ��2�"�(*����� �:�_7�~�\�����#��a��{��_�:�<2��	�� �����

 �!( �>����(�7��A0��n�q�  ���PARITY set error Ñ> !>2����ΐϓŖ͙�  � !�!�!�!�:��2�������  � !:��2N�Ñ�A0���SOLI��SLO��FAS�  ���Cursor error Ñ !`!@��1͝�0�W��1͝�0_>
� S<� Ñ��(��Q���1��y� ��x0��>02z�P�>12z�PÑ �x���bx�� ��x� ��tx� ���� G0 x���G0 ��1�k0'��
   |��}����:  �����#�Ñ��DUMP HEX error      ��1�k0�A0�v0���1�\# �Ñ��POKE HEX data error      �*�~�A8b�0^#"�2��A0R�� 8-�� 8-� 9-�� 9-� 10-�� 10-� 11-�� 11-�  �0�.B��:�O 		^#V�++�s� Ñ��DRV parameter error     �@0 �͙�0 �0�2���  Ñ*�+*�����   ,bad of missing COLOR parameter
 Î͙0 
�02��Ñ*�+*�����   ,bad of missing VOL parameter
 Î͙0<����~�x(8��2R�Ñ*�����   ,bad of missing FEEL parameter
 Î�A���� 120� 60� 30� 15� 13� 11� 7� 5�  ����q.?��Ñ��BAUD RATE parmater missing
 Ñ.<��7 �: g��A0��5	O�;	OF�  ����40COL parmater missing
 Ñ�x��x���yÑni� 2r�A�(
�~	O*�~#�/(k�:(!��DATE set error    �͝0��߯2q"�y��
2p͝0 ���
2q*�~#�: "�͝hn� *�~�\ʑ�  �#"��"�!  "n!V�
�~	�� 
*�~#�/�f	"��~	�� *n�< ͳ
8�#"n��N�f	!(�
�O 		^#V*n"n���
Current Date is:   �[
�:p��:q��:r��Ñ*n>w*͑
�� � }�< .>
8+�X͑
��}��
�������'2�N#F#ͳ
:�(0�+++F+N��͹
��z��{��}�o|�g����
0��
Ox���!H�!J���A�0 "���$CB�-ASCI�)MPS100�  ���printer parameter missing
 Ñ̓)>�͝8�2�̓ #+ͷ +++Ϳ ++:���+ 
�*�s#rÑ��CAN NOT install print Filter
 Ñ!�'���� ##���� >���++>���*�^#V�Ϳ�ͷ�����������#�����###����T]���y��������OT]>��������* .Z���1��*�OG�((�� 	�# ��(���(�� �� �7"�`i����*�+#~� (�"�����1*�~#�\(�= �"��17����� ��,��,�� ��v�g�v�o��͈�G͈а�7�;��?���#"�7��A�;!  �DM))	)O 	�;�8�}$%7��A�*�~�0?��
�#"�7�~�\��#��������~#�������>/�>:������Ɛ'�@'�> >�>
����_� �����  m�H�"��	j�D���g�A���c   ; Z x � � � � 0N     
            CONF    HLP                                                                                                                     