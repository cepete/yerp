module Handler.Company 
       ( getCompaniesR
       , getCompanyR
       , postCompanyCreateR
       , getCompanyCreateR
       )
where

import Handler.Forms
import Import
 
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
            uid <- requireAuthId
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
