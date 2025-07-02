object AppDataModule: TAppDataModule
  OnCreate = DataModuleCreate
  Height = 268
  Width = 143
  PixelsPerInch = 120
  object Connection: TFDConnection
    Params.Strings = (
      'StringFormat=Unicode'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 40
    Top = 32
  end
  object Query: TFDQuery
    Connection = Connection
    SQL.Strings = (
      '')
    Left = 40
    Top = 128
  end
end
