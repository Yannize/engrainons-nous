module.exports={
    api404(_, response){
        response.status(404).json({error: 'resource not found psst !! Php is Better :)'});
    }
}