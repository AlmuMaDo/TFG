function dataS11_norm = NormalizarFunctionCompareS11(dataS11, t0, tf)
% funcion para normalizar las muestras 
% t0 sera el valor de "tiempo" inicial una vez normalizado
% tf sera el valor de "tiempo" final una vez normalizado

%% inicializar estructura salida
dataS11_norm = dataS11;

%% frecuencia muestreo normalizada
% ver cuantas muestras se han tomado en total y sacar la nueva frecuencia 
% de muestreo normalizada para la escala entre t0 y tf

n_samples = numel(dataS11.time);
% new_frec = (tf - t0)/n_samples;

%% reescalar tiempo para normalizar entre t0 y tf
dataS11_norm.time = linspace(t0, tf, n_samples)';
end