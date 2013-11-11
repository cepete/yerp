module Handler.Forms
where

import Import
import Data.Time
import Prelude


companyForm :: Form Company
companyForm = renderDivs $ Company
    <$> areq    textField "Name" Nothing
    <*> areq    intField "Parent Id" Nothing
    <*> areq    intField "Partner Id" Nothing
    <*> aopt    (selectField currencies) "Currency Id" Nothing
    <*> areq    intField "Create User" Nothing
    <*> lift (liftIO getCurrentTime)
    <*> lift (liftIO getCurrentTime)
    <*> areq    intField "Write User" Nothing
    <*> aopt    textareaField "Footer" Nothing
    <*> areq    textareaField "Header" Nothing 
    <*> areq    textField "Paper_format" Nothing
    <*> aopt    textField "Logo_web" Nothing
    <*> areq    textareaField "Rml_header2" Nothing
    <*> areq    textareaField "Rml_header3" Nothing
    <*> areq    textareaField "Rml Header1" Nothing
    <*> aopt    textField "Account" Nothing
    <*> aopt    textField "Company Registry" Nothing
    <*> aopt    boolField "Custom Footer" Nothing
    <*> areq    boolField "Expects COA" Nothing
    <*> aopt    textField "Paypal Account" Nothing
    <*> areq    textField "Overdue Msg" Nothing
    <*> areq    textField "Tax Rounding Method" Nothing 
    <*> areq    doubleField "Schedule Range" Nothing
    <*> areq    intField "EC_Exchange Account" Nothing
    <*> areq    intField "IC Exchange Account" Nothing
    <*> areq    doubleField "Security Lead" Nothing
    where
        currencies :: HandlerT App IO (OptionList (Key Currency))
        currencies = do	       	   
            entities <- runDB $ selectList [] [Asc CurrencyName]
            optionsPairs $ Prelude.map (\cat -> (currencyName $ entityVal cat, entityKey cat)) entities
