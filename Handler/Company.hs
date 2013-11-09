module Handler.Company 
       ( getCompaniesR
       , getCompanyR
       , postCompanyCreateR
       , getCompanyCreateR
       )
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

 
getCompaniesR :: Handler Html 
getCompaniesR = do
    --Get the list of articles inside the database. 
    companies <- runDB $ selectList [] [Desc CompanyName]
    --We'll need the two "objects": companyWidget and enctype
    -- to construct the form (see templates/articles.hamlet).
 --   (companyWidget, enctype) <- generateFormPost companyForm
    defaultLayout $ do
        $(widgetFile "companies")

getCompanyR :: CompanyId -> Handler Html
getCompanyR companyId = do
--            uid <- requireAuthId
            company <- runDB $ get404 companyId
            defaultLayout $ do
                          setTitle $ toHtml $ companyName company
                          $(widgetFile "company")

--postCompanyR :: Handler Html
--postCompanyR = do
--    ((res,companyWidget), enctype) <- runFormPost companyForm
--    case res of
--        FormSuccess company -> do
--            companyId <- runDB $ insert company
--            setMessage $ toHtml $ (companyName company) <> " created"
--            redirect $ CompanyR companyId
--        _ -> defaultLayout $ do
--                setTitle "Please correct your entry form"
--                $(widgetFile "companyAddError")

getCompanyCreateR :: Handler Html
getCompanyCreateR = do
    (companyCreateWidget, enctype) <- generateFormPost companyForm
    defaultLayout $ do
                  setTitle "Enter Company Info"
                  $(widgetFile "companyCreate")

postCompanyCreateR :: Handler Html
postCompanyCreateR = do
    ((res, companyCreateWidget), enctype) <- runFormPost companyForm
    case res of
        FormSuccess company -> do
            companyId <- runDB $ insert company
            setMessage $ toHtml $ (companyName company) <> " created"
            redirect $ CompanyR companyId
        _ -> defaultLayout $ do
                  setTitle "Please correct your entry form"
                  $(widgetFile "companyAddError")