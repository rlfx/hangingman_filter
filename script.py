import pickle
import numpy as np
fr = open('hangingman_filter_1.pkl','rb')
info = pickle.load(fr)
np.savetxt('kernel_close_price.csv', info[:,:,0],delimiter=',')
np.savetxt('kernel_realbody.csv',    info[:,:,1],delimiter=',')
np.savetxt('kernel_uppershadow.csv', info[:,:,2],delimiter=',')
np.savetxt('kernel_lowershadow.csv', info[:,:,3],delimiter=',')
